
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hms_portfolio/bloc/repo.dart';
import 'package:hms_portfolio/components/constants.dart';
import '../models/models.dart';



abstract class EventsState{}

class EventsInitial extends EventsState{}

class EventsLoading extends EventsState{}

class EventsLoaded extends EventsState{

  final List<HospitalEvent> _events;

  HospitalEvent? get flagshipEvent{

    if(_events.isEmpty) return null;

    return _events.where((event) => event.isFlagshipEvent)
      .toList().firstOrNull;

  }

  EventCategory? _eventCategory;

  EventsLoaded(this._events);

  List<HospitalEvent> get eventsFilter{
    if(_eventCategory == null) return _events;

    return _events.where((event) => event.category == _eventCategory).toList();
  }


  void applyFilter(EventCategory? eventCategory) => _eventCategory = eventCategory;

}

class EventsError extends EventsState{
  final String message;
  EventsError(this.message);

}


class EventsCubit extends Cubit<EventsState>{

  EventsCubit() : super(EventsInitial());


  void fetchEvents() async {

    debugPrint('[EventsCubit] Loading events please wait');

    emit(EventsLoading());

    //TODO: remove the sample events from loaded emission.
    try{

      final events = await Repository.getEvents();
      emit(EventsLoaded(events + sampleEvents));

      debugPrint('[EventsCubit] Events loaded');

    }catch(ex, stackTrace){

      debugPrintStack(label: ex.toString(), stackTrace: stackTrace);
      emit(EventsError(ex.toString()));

    }

  }
}