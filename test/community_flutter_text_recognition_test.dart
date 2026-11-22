import 'package:community_flutter_text_recognition/community_flutter_text_recognition.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('community_flutter_text_recognition');
  final calls = <MethodCall>[];
  Object? Function(MethodCall call) answer = (_) => null;

  setUp(() {
    calls.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (call) async {
      calls.add(call);
      return answer(call);
    });
  });

  tearDown(() => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null));

  test('recognize sends the image bytes and returns the text', () async {
    answer = (_) => 'Hello\nWorld';
    final bytes = Uint8List.fromList([1, 2, 3]);
    expect(await CommunityTextRecognition.recognize(bytes), 'Hello\nWorld');
    expect(calls.single.method, 'recognize');
    expect((calls.single.arguments as Map)['image'], bytes);
  });

  test('a null platform answer is no text / not available', () async {
    answer = (_) => null;
    expect(await CommunityTextRecognition.recognize(Uint8List(0)), '');
    expect(await CommunityTextRecognition.isAvailable(), isFalse);
  });

  test('isAvailable passes the platform answer through', () async {
    answer = (_) => true;
    expect(await CommunityTextRecognition.isAvailable(), isTrue);
    expect(calls.single.method, 'isAvailable');
  });

  test('a platform error reaches the caller', () async {
    answer = (_) => throw PlatformException(code: 'decode_failed', message: 'not an image');
    expect(() => CommunityTextRecognition.recognize(Uint8List(1)), throwsA(isA<PlatformException>()));
  });
}
