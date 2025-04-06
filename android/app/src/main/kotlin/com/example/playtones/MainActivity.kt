package com.example.playtones
import android.media.AudioManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.ryanheise.audioservice.AudioServiceActivity

class CustomAudioServiceActivity : AudioServiceActivity() {
    private val CHANNEL = "change_audio"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            val audioManager = getSystemService(AUDIO_SERVICE) as AudioManager
            when (call.method) {
                "switchToSpeaker" -> {
                    audioManager.mode = AudioManager.MODE_IN_COMMUNICATION
                    audioManager.isSpeakerphoneOn = true 
                    audioManager.isBluetoothScoOn = false
                    audioManager.isWiredHeadsetOn = false
                    result.success(null)
                }
                "switchToHeadphones" -> {
                     audioManager.mode = AudioManager.MODE_IN_COMMUNICATION 
                     audioManager.isSpeakerphoneOn = false 
                    audioManager.isBluetoothScoOn = false 
                    audioManager.isWiredHeadsetOn = true 
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }
}