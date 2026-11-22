import Flutter
import UIKit
import Vision

/// OCR of an encoded image with the Vision framework (`VNRecognizeTextRequest`).
public class CommunityFlutterTextRecognitionPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "community_flutter_text_recognition", binaryMessenger: registrar.messenger())
    registrar.addMethodCallDelegate(CommunityFlutterTextRecognitionPlugin(), channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "isAvailable":
      result(true)
    case "recognize":
      guard let args = call.arguments as? [String: Any], let data = args["image"] as? FlutterStandardTypedData else {
        result(FlutterError(code: "bad_args", message: "image bytes are required", details: nil))
        return
      }
      recognize(data.data, result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func recognize(_ data: Data, result: @escaping FlutterResult) {
    guard let image = UIImage(data: data), let cgImage = image.cgImage else {
      result(FlutterError(code: "decode_failed", message: "The image could not be decoded", details: nil))
      return
    }
    let request = VNRecognizeTextRequest { request, error in
      if let error = error {
        DispatchQueue.main.async { result(FlutterError(code: "recognize_failed", message: error.localizedDescription, details: nil)) }
        return
      }
      let lines = (request.results as? [VNRecognizedTextObservation] ?? []).compactMap { $0.topCandidates(1).first?.string }
      DispatchQueue.main.async { result(lines.joined(separator: "\n")) }
    }
    request.recognitionLevel = .accurate
    request.usesLanguageCorrection = true
    let orientation = CGImagePropertyOrientation(image.imageOrientation)
    DispatchQueue.global(qos: .userInitiated).async {
      do {
        try VNImageRequestHandler(cgImage: cgImage, orientation: orientation, options: [:]).perform([request])
      } catch {
        DispatchQueue.main.async { result(FlutterError(code: "recognize_failed", message: error.localizedDescription, details: nil)) }
      }
    }
  }
}

extension CGImagePropertyOrientation {
  init(_ orientation: UIImage.Orientation) {
    switch orientation {
    case .up: self = .up
    case .down: self = .down
    case .left: self = .left
    case .right: self = .right
    case .upMirrored: self = .upMirrored
    case .downMirrored: self = .downMirrored
    case .leftMirrored: self = .leftMirrored
    case .rightMirrored: self = .rightMirrored
    @unknown default: self = .up
    }
  }
}
