part of 'image_url_bloc.dart';

@immutable
sealed class ImageUrlEvent {}


final class ImageAddedEvent extends ImageUrlEvent{
  final String imageUrl;

  ImageAddedEvent({required this.imageUrl});
}