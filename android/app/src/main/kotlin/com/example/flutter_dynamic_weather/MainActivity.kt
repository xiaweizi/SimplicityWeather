package com.example.flutter_dynamic_weather

import android.os.Bundle
import android.util.Log
import com.example.flutter_dynamic_weather.base.CommonUtils
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    companion object {
        private const val CHANNEL_NAME = "com.example.flutter_dynamic_weather/router"
        private const val START_ACTIVITY = "startActivity"
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val nativeChannel = MethodChannel(flutterEngine?.dartExecutor, CHANNEL_NAME)

        nativeChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                START_ACTIVITY -> {
                    val name = call.argument<String>("name")
                    if (name == "minute") {
                        // 跳转到降雨二级页
                        CommonUtils.startMinutePage(this)
                    }
                }
            }
        }

    }
}
