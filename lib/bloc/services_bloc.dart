
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:hms_portfolio/models/models.dart';
import 'repo.dart';

abstract class ServicesState{}

class ServicesInitial extends ServicesState{}

class ServicesLoading extends ServicesState{}

class ServicesLoaded extends ServicesState{

  final List<HospitalService> generalServices;
  final List<HospitalService> specializedServices;

  ServicesLoaded({required this.generalServices, required this.specializedServices});

}

class ServicesError extends ServicesState{
  final String message;

  ServicesError(this.message);
}


class ServicesCubit extends Cubit<ServicesState>{

  ServicesCubit() : super(ServicesInitial());

  void fetchServices() async {
    emit(ServicesLoading());

    try{
      final List<HospitalService> services = await  Repository.fetchHospitalServices();
      emit(ServicesLoaded(  
        generalServices: services.where((service) => service.serviceType == ServiceType.general).toList(),
        specializedServices: services.where((service) => service.serviceType == ServiceType.specialized).toList()
      ));
    }catch(e){
      emit(ServicesError(e.toString()));
    }
  }


  void dispose(){
    emit(ServicesInitial());
  }
}