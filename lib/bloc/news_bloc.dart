
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hms_portfolio/bloc/repo.dart';
import '../models/models.dart';

abstract class NewsState{}

class NewsInitial extends NewsState{}

class NewsLoading extends NewsState{}

class NewsLoaded extends NewsState{

  final NewsArticle? featuredArticle;
  final List<NewsArticle> newsArticles;

  NewsLoaded({
    this.featuredArticle,
    required this.newsArticles
  });
}

class NewsError extends NewsState{

  final String message;
  NewsError(this.message);
}


class NewsCubit extends Cubit<NewsState>{

  NewsCubit() : super(NewsInitial());

  void fetchNewsArticles() async {

    emit(NewsLoading());

    try{

      final articles = await Repository.getNews();

      final featured = articles.where((article) => article.isFeatured).firstOrNull;

      emit(NewsLoaded(  
        featuredArticle: featured, 
        newsArticles: articles
      ));
      
    }catch(ex){
      emit(NewsError(ex.toString()));
    }

  }
}