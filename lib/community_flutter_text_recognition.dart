/// On-device text recognition (OCR) of an encoded image (JPEG / PNG bytes).
///
/// Android uses ML Kit's Latin text recognizer through Google Play services (the model is downloaded
/// by Play services, nothing is bundled in the app); iOS uses the Vision framework
/// (`VNRecognizeTextRequest`, accurate level with language correction). Nothing leaves the device.
library;

import 'package:flutter/services.dart';

class CommunityTextRecognition {
  CommunityTextRecognition._();

  static const MethodChannel _channel = MethodChannel('community_flutter_text_recognition');

  /// True when the platform can recognise text (Android: Play services present; iOS 13+).
  static Future<bool> isAvailable() async => await _channel.invokeMethod<bool>('isAvailable') ?? false;

  /// The text found in [image], lines separated by `\n` ('' when there is none). Throws a
  /// [PlatformException] when the image cannot be decoded or the engine fails.
  static Future<String> recognize(Uint8List image) async =>
      await _channel.invokeMethod<String>('recognize', {'image': image}) ?? '';
}
