package com.example.flutter_dynamic_weather

import android.os.Bundle
import android.util.Log
import com.example.flutter_dynamic_weather.base.CommonUtils
import com.example.flutter_dynamic_weather.fragment.JikeFragment
import com.example.flutter_dynamic_weather.fragment.ZhuGeFragment
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    companion object {
        private const val CHANNEL_NAME = "com.example.flutter_dynamic_weather/router"
        private const val START_ACTIVITY = "startActivity"
        private const val ACTIVITY_NAME = "minute"
        private const val ACTIVITY_ZHUGE = "zhuge"
        private const val ACTIVITY_JIKE = "jike"
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val nativeChannel = MethodChannel(flutterEngine?.dartExecutor, CHANNEL_NAME)

        nativeChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                START_ACTIVITY -> {
                    val name = call.argument<String>("name")
                    if (name == ACTIVITY_NAME) {
                        // 跳转到降雨二级页
                        CommonUtils.startMinutePage(this)
                    } else if (name == ACTIVITY_ZHUGE) {
                        CommonUtils.startModuleActivity(this, ZhuGeFragment::class.java.name)
                    } else if (name == ACTIVITY_JIKE) {
                        CommonUtils.startModuleActivity(this, JikeFragment::class.java.name)
                    }
                }
            }
        }

    }
}
