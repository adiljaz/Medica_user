part of 'image_adding_bloc.dart';

@immutable
abstract class ImageAddingState {}

class ImageAddingInitial extends ImageAddingState {}

class ImageSelectedState extends ImageAddingState {
  final String imageUrl;

  ImageSelectedState({required this.imageUrl});
}

class ImageSelectedNotDone extends ImageAddingState {}

class ImageSelectedError extends ImageAddingState {}
