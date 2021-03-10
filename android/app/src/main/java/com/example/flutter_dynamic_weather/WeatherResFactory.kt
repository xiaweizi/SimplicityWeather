package com.example.flutter_dynamic_weather

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import com.example.flutter_dynamic_weather.base.ApiManager

/**
 * <pre>
 *     class  : com.example.flutter_dynamic_weather.WeatherResFactory
 *     time   : 2021/03/10
 *     desc   : 资源工厂
 * </pre>
 */
class WeatherResFactory private constructor() {

    var rainBitmap: Bitmap? = null
    var isPrepare = false

    companion object {
        val instance by lazy {
            WeatherResFactory()
        }
    }

    fun prepareRes(context: Context) {
        rainBitmap = BitmapFactory.decodeResource(context.resources, R.mipmap.rain)
        isPrepare = true
    }
}