

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hms_portfolio/bloc/repo.dart';
import 'package:hms_portfolio/models/models.dart';


abstract class GalleryState{}

class GalleryInitial extends GalleryState{}

class GalleryLoading extends GalleryState{}

class GalleryLoaded extends GalleryState{
  final List<GalleryItem> galleryItems;

  GalleryLoaded(this.galleryItems);
}

class GalleryError extends GalleryState{
  final String error;
  GalleryError(this.error);
}

class GalleryCubit extends Cubit<GalleryState>{

  GalleryCubit() : super(GalleryInitial());

  void fetchGalleryImages() async {

    emit(GalleryLoading());

    try{
      final galleryItems = await Repository.fetchGalleryItems();
      emit(GalleryLoaded(galleryItems));
    }catch(ex){
      emit(GalleryError(ex.toString()));
    }
  }

}