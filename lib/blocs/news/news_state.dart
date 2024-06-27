import 'package:fire_login/screens/news/newmodel.dart';

abstract class NewsStates {}

class NewsInitialState extends NewsStates {}

class NewsLoadingState extends NewsStates {}

class NewsLoadedState extends NewsStates {
  final List<Articles> newsList;

  NewsLoadedState({required this.newsList});
}

class NewsErrorState extends NewsStates {
  final String errorMessage;

  NewsErrorState({required this.errorMessage});
}
