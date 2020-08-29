import 'dart:ui';
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:flutter/services.dart';

class ImageUtils {
  static Future<ui.Image> getImage(String asset) async {
    ByteData data = await rootBundle.load(asset);
    Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }
}