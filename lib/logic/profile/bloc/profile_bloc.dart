import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/profile_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _repository;
  StreamSubscription<String?>? _authSub;

  ProfileBloc(this._repository) : super(const ProfileInitial()) {
    on<ProfileStarted>(_onStarted);
    on<ProfileUserChanged>(_onUserChanged);
    on<ProfileRequested>(_onRequested);
  }

  Future<void> _onStarted(
    ProfileStarted event,
    Emitter<ProfileState> emit,
  ) async {
    _authSub?.cancel();
    _authSub = _repository.userIdStream.listen((uid) {
      add(ProfileUserChanged(uid));
    });
  }

  Future<void> _onUserChanged(
    ProfileUserChanged event,
    Emitter<ProfileState> emit,
  ) async {
    if (event.userId == null || event.userId!.isEmpty) {
      emit(const ProfileEmpty());
      return;
    }
    emit(const ProfileLoading());
    try {
      final user = await _repository.fetchUserById(event.userId!);
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onRequested(
    ProfileRequested event,
    Emitter<ProfileState> emit,
  ) async {
    // Explicit refresh based on latest auth user
    // This ensures manual refresh from UI if needed
    final completer = Completer<void>();
    _authSub?.cancel();
    _authSub = _repository.userIdStream.listen((uid) async {
      if (uid == null || uid.isEmpty) {
        emit(const ProfileEmpty());
        completer.complete();
        return;
      }
      emit(const ProfileLoading());
      try {
        final user = await _repository.fetchUserById(uid);
        emit(ProfileLoaded(user));
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
      completer.complete();
    });
    await completer.future;
  }

  @override
  Future<void> close() {
    _authSub?.cancel();
    return super.close();
  }
}
