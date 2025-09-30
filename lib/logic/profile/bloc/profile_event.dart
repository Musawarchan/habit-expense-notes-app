import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileStarted extends ProfileEvent {
  const ProfileStarted();
}

class ProfileUserChanged extends ProfileEvent {
  final String? userId;
  const ProfileUserChanged(this.userId);

  @override
  List<Object?> get props => [userId];
}

class ProfileRequested extends ProfileEvent {
  const ProfileRequested();
}

class ProfileUpdateRequested extends ProfileEvent {
  final String name;
  const ProfileUpdateRequested(this.name);

  @override
  List<Object?> get props => [name];
}

class ProfilePhotoUpdateRequested extends ProfileEvent {
  final String photoUrl;
  const ProfilePhotoUpdateRequested(this.photoUrl);

  @override
  List<Object?> get props => [photoUrl];
}
