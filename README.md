# community_flutter_text_recognition

On-device text recognition (OCR) for Flutter apps.

<!-- support:top:start -->
## ❤️ Support this plugin

I build and maintain this plugin, and [a whole family of free Flutter plugins](https://github.com/EYALIN?tab=repositories&q=community_flutter), in my free time. Every Android and iOS release changes something underneath them (new SDK levels, Swift Package Manager, privacy manifests, OEM quirks), and keeping them working takes hours every month.

**If this plugin saved you from writing the platform code yourself, or it ships in an app that earns money, please sponsor its development.** Even $5 a month makes a real difference. It decides how fast issues get fixed, how quickly the plugin supports each new Android and iOS release, and which features come next. Issues and feature requests from sponsors are looked at first.

[![Sponsor Me](https://img.shields.io/static/v1?label=Sponsor%20Me&style=for-the-badge&message=%E2%9D%A4&logo=GitHub&color=%23fe8e86)](https://github.com/sponsors/EYALIN)

Not able to sponsor? A ⭐ on [GitHub](https://github.com/EYALIN) and a 👍 on pub.dev help other developers find it. Thank you!
<!-- support:top:end -->

| | Android | iOS |
|---|---|---|
| Minimum | API 24 | iOS 15 |
| Engine | ML Kit Latin text recognizer via Google Play services (`play-services-mlkit-text-recognition`; the model is delivered by Play services, not bundled) | Vision `VNRecognizeTextRequest` (accurate level, language correction) |
| Permission needed | none | none |

The image never leaves the device.

## Install

```sh
flutter pub add community_flutter_text_recognition
```

## Usage

```dart
import 'dart:typed_data';

import 'package:community_flutter_text_recognition/community_flutter_text_recognition.dart';

Future<String?> readText(Uint8List jpegOrPng) async {
  if (!await CommunityTextRecognition.isAvailable()) return null;
  return CommunityTextRecognition.recognize(jpegOrPng); // lines separated by '\n'
}
```

- `CommunityTextRecognition.isAvailable()` - whether the platform engine can run.
- `CommunityTextRecognition.recognize(Uint8List image)` - the text of an encoded JPEG / PNG image,
  lines separated by `\n`.

See [example/lib/main.dart](example/lib/main.dart) for a complete app.

## License

MIT — see [LICENSE](LICENSE). Issues and pull requests are welcome at
[github.com/EYALIN/community_flutter_text_recognition](https://github.com/EYALIN/community_flutter_text_recognition/issues).

<!-- support:bottom:start -->
## Support

If this plugin is useful to you, please [sponsor its development](https://github.com/sponsors/EYALIN). It keeps the plugin maintained for every new Android and iOS release.
<!-- support:bottom:end -->
