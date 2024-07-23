part of 'image_adding_bloc.dart';

@immutable
abstract class ImageAddingEvent {}

class ImageChangedEvent extends ImageAddingEvent {
  final String imageUrl;

  ImageChangedEvent(this.imageUrl);
}

class ImageCleared extends ImageAddingEvent {}
 