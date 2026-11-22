#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint community_flutter_text_recognition.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'community_flutter_text_recognition'
  s.version          = '1.0.0'
  s.summary          = 'On-device text recognition (OCR) for Flutter with Apple Vision.'
  s.description      = <<-DESC
Recognizes the text of a JPEG or PNG image on the device with VNRecognizeTextRequest (accurate level, language correction).
                       DESC
  s.homepage         = 'https://github.com/EYALIN/community_flutter_text_recognition'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Community Flutter Plugins' => 'community-flutter-plugins@users.noreply.github.com' }
  s.source           = { :path => '.' }
  s.source_files = 'community_flutter_text_recognition/Sources/community_flutter_text_recognition/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '15.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'community_flutter_text_recognition_privacy' => ['community_flutter_text_recognition/Sources/community_flutter_text_recognition/PrivacyInfo.xcprivacy']}
end
