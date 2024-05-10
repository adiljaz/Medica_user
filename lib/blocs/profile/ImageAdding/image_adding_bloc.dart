import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'image_adding_event.dart';
part 'image_adding_state.dart';

class ImageAddingBloc extends Bloc<ImageAddingEvent, ImageAddingState> {
  ImageAddingBloc() : super(ImageAddingInitial()) {
    on<ImageChangedEvent>(
      (event, emit) async {
        emit(ImageSelectedState(imageUrl: event.imageUrl));
      },
    );
  }
}
