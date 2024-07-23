import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'date_of_birth_event.dart';
import 'date_of_birth_state.dart';

class DateOfBirthBloc extends Bloc<DateOfBirthEvent, DateOfBirthState> {
  DateOfBirthBloc() : super(DateOfBirthInitial()) {
    on<DateOfBirthSelected>(_onDateOfBirthSelected);
    on<DateOfBirthCleared>(_onDateOfBirthCleared);
  }

  void _onDateOfBirthSelected(DateOfBirthSelected event, Emitter<DateOfBirthState> emit) {
    final formattedDate = DateFormat('yyyy-MM-dd').format(event.selectedDate);
    emit(DateOfBirthSelectedState(formattedDate));
  }

  void _onDateOfBirthCleared(DateOfBirthCleared event, Emitter<DateOfBirthState> emit) {
    emit(DateOfBirthInitial());
  }
}