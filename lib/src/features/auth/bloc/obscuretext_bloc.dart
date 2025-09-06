import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'obscuretext_event.dart';
part 'obscuretext_state.dart';

class ObscuretextBloc extends Bloc<ObscuretextEvent, ObscuretextState> {
  ObscuretextBloc() : super(ObscuretextInitial(value: true)) {
    on<ObscureButtonTapEvent>((event, emit) {
      final currentState = state as ObscuretextInitial;
      emit(ObscuretextInitial(value: !currentState.value));
    });
  }
}
