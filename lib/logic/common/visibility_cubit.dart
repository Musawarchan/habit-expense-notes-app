import 'package:flutter_bloc/flutter_bloc.dart';

class VisibilityCubit extends Cubit<bool> {
  VisibilityCubit({bool initial = false}) : super(initial);

  void toggle() => emit(!state);
  void show() => emit(true);
  void hide() => emit(false);
}
