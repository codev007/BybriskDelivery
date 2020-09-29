import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageHelper {
  // 4. compress List<int> and get another List<int>.
  Future<List<int>> compressImage(List<int> list) async {
    var result = await FlutterImageCompress.compressWithList(
      list,
      quality: 60,
    );
    print(list.length);
    print(result.length);
    return result;
  }
}
