
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hms_portfolio/bloc/repo.dart';
import '../models/models.dart';


abstract class EventsState{}

class EventsInitial extends EventsState{}

class EventsLoading extends EventsState{}

class EventsLoaded extends EventsState{

  final List<HospitalEvent> _events;

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

    emit(EventsLoading());

    try{
      final events = await Repository.getEvents();
      emit(EventsLoaded(events));
    }catch(ex){
      emit(EventsError(ex.toString()));
    }

  }
}