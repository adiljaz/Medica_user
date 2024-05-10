import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppRoundedImage extends StatelessWidget {
  final ImageProvider provider;
  final double height;
  final double weight;
  const AppRoundedImage(
    this.provider, {super.key, 
    required this.height,
    required this.weight,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: Image(
        image: provider,
        height: height,
        width: weight,
      ),
    );
  }
  factory AppRoundedImage.url(String url ,{required double height,required double width}){
    return AppRoundedImage(NetworkImage(url), height: height, weight: width);
  }
  factory AppRoundedImage.memory(Uint8List data ,{required double height,required double width}){
    return AppRoundedImage(MemoryImage(data), height: height, weight: width);
  }
}
