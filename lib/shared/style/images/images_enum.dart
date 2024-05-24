import 'package:flutter_gemini_ai/shared/utils/extensions/string_ext.dart';

enum ImagesEnum {
  robotMini,
  ;

  const ImagesEnum();

  String get path => 'assets/images/${name.camelToSnakeCase}.png';
}
