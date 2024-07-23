import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'image_adding_event.dart';
part 'image_adding_state.dart';

class ImageAddingBloc extends Bloc<ImageAddingEvent, ImageAddingState> {
  ImageAddingBloc() : super(ImageAddingInitial()) {
    on<ImageChangedEvent>(_onImageChanged);
    on<ImageCleared>(_onImageCleared);
  }

  void _onImageChanged(ImageChangedEvent event, Emitter<ImageAddingState> emit) {
    emit(ImageSelectedState(imageUrl: event.imageUrl));
  }

  void _onImageCleared(ImageCleared event, Emitter<ImageAddingState> emit) {
    emit(ImageAddingInitial());
  }

  void clearImage() {
    add(ImageCleared());
  }
} 