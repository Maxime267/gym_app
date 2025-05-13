  import 'package:bloc/bloc.dart';
  import 'event.dart';
  import 'state.dart';

class DrawerBloc extends Cubit<DrawerState> {
  DrawerBloc() : super(DrawerState(0));

  void updateValue(int newValue) => emit(DrawerState(newValue));
}
