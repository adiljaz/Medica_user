import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'image_url_event.dart';
part 'image_url_state.dart';

class ImageUrlBloc extends Bloc<ImageUrlEvent, ImageUrlState> {
  ImageUrlBloc() : super(ImageUrlInitial()) {
    on< ImageAddedEvent>((event, emit) async {
      emit(ImageSelectedState(imageUrl: event.imageUrl));
    });
  }
}
