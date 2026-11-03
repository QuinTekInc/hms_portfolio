
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hms_portfolio/bloc/repo.dart';

abstract class AppointmentState{}
class AppointmentInitial extends AppointmentState{}

class AppointmentLoading extends AppointmentState{}

class AppointmentSubmitted extends AppointmentState{}

class AppointmentError extends AppointmentState{
  final String message;
  AppointmentError(this.message);
}


class AppointmentCubit extends Cubit<AppointmentState>{

  AppointmentCubit() : super(AppointmentInitial());

  void makeAppointment({
    required String name, 
    required String phoneNumber, 
    required String email, 
    required String department,
    required DateTime appointmentDate,
    String? notes
  }) async {

    emit(AppointmentLoading());

    await Future.delayed(Duration(seconds: 5), (){});

    try{
      await Repository.bookAppointment({
        'name': name, 
        'phone_number': phoneNumber,
        'email': email, 
        'department': department, 
        'appointment_date': appointmentDate, 
        'notes': ?notes
      });
    }catch(ex){
      emit(AppointmentError(ex.toString()));
    }

  }
}