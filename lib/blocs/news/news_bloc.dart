import 'package:bloc/bloc.dart';
import 'package:fire_login/blocs/news/news_state.dart';
import 'package:fire_login/screens/news/newmodel.dart';
import 'package:fire_login/screens/news/repository/repository.dart';

import 'news_event.dart';

class NewsBloc extends Bloc<NewsEvent, NewsStates> {
  final NewsaRepository newsaRepository;

  NewsBloc({required this.newsaRepository}) : super(NewsInitialState()) {
    on<StartEvent>((event, emit) async {
      try {
        emit(NewsLoadingState());
        List<Articles> newsList = await newsaRepository.fetchNews();
        emit(NewsLoadedState(newsList: newsList));
      } catch (e) {
        emit(NewsErrorState(errorMessage: e.toString()));
      }
    });
  }
}
