import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImageEvent {}

abstract class ImageState {}

class ImageLoaded extends ImageState {
  final Uint8List imgData;
  ImageLoaded(this.imgData);
}

class ImageLoading extends ImageState {}

class GetImage extends ImageEvent {
  Uint8List? imgData;
  GetImage(this.imgData);
}

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  ImageBloc(ImageState initialState) : super(initialState) {
    on<GetImage>(_getImage);
  }

  Future<void> _getImage(GetImage event, Emitter<ImageState> emit) async {
    ByteData? imageData;
    await rootBundle
        .load('assets/noimage.jpg')
        .then((data) => imageData = data);
    emit(ImageLoading());
    if (event.imgData != null) {
      emit(ImageLoaded(event.imgData!));
    } else {
      if (imageData == null) {
        emit(ImageLoading());
      } else {
        emit(ImageLoaded(imageData!.buffer.asUint8List()));
      }
    }
  }
}
