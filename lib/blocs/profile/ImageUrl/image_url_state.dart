part of 'image_url_bloc.dart';

@immutable
sealed class ImageUrlState {}

final class ImageUrlInitial extends ImageUrlState {}

final class ImageSelectedState extends ImageUrlState{
  final String imageUrl;

  ImageSelectedState({required this.imageUrl});
  
}

class ImageselectedDone extends ImageUrlState{}

class ImageError extends ImageUrlState{}

