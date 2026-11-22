package com.community.flutter.textrecognition

import android.content.Context
import android.graphics.BitmapFactory
import com.google.android.gms.common.ConnectionResult
import com.google.android.gms.common.GoogleApiAvailability
import com.google.mlkit.vision.common.InputImage
import com.google.mlkit.vision.text.TextRecognition
import com.google.mlkit.vision.text.TextRecognizer
import com.google.mlkit.vision.text.latin.TextRecognizerOptions
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/** OCR of an encoded image with ML Kit's Latin text recognizer (Google Play services). */
class CommunityFlutterTextRecognitionPlugin : FlutterPlugin, MethodChannel.MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private var recognizer: TextRecognizer? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        channel = MethodChannel(binding.binaryMessenger, "community_flutter_text_recognition")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        recognizer?.close()
        recognizer = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "isAvailable" -> result.success(
                GoogleApiAvailability.getInstance().isGooglePlayServicesAvailable(context) == ConnectionResult.SUCCESS
            )
            "recognize" -> recognize(call.argument<ByteArray>("image"), result)
            else -> result.notImplemented()
        }
    }

    private fun recognize(bytes: ByteArray?, result: MethodChannel.Result) {
        val bitmap = bytes?.let { BitmapFactory.decodeByteArray(it, 0, it.size) }
        if (bitmap == null) {
            result.error("decode_failed", "The image could not be decoded", null)
            return
        }
        val engine = recognizer ?: TextRecognition.getClient(TextRecognizerOptions.DEFAULT_OPTIONS).also { recognizer = it }
        engine.process(InputImage.fromBitmap(bitmap, 0))
            .addOnSuccessListener { text -> result.success(text.text) }
            .addOnFailureListener { e -> result.error("recognize_failed", e.message, null) }
    }
}
