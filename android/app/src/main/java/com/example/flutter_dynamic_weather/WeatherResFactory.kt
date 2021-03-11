package com.example.flutter_dynamic_weather

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.util.Log
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
    var thunderBitmap = arrayListOf<Bitmap?>()
    var isPrepare = false

    companion object {
        private const val TAG = "Weather-Res:"
        val instance by lazy {
            WeatherResFactory()
        }
    }

    fun prepareRes(context: Context) {
        val lastTime = System.currentTimeMillis()
        rainBitmap = BitmapFactory.decodeResource(context.resources, R.mipmap.rain)
        thunderBitmap.clear()
        thunderBitmap.add(BitmapFactory.decodeResource(context.resources, R.mipmap.lightning0))
        thunderBitmap.add(BitmapFactory.decodeResource(context.resources, R.mipmap.lightning1))
        thunderBitmap.add(BitmapFactory.decodeResource(context.resources, R.mipmap.lightning2))
        thunderBitmap.add(BitmapFactory.decodeResource(context.resources, R.mipmap.lightning3))
        thunderBitmap.add(BitmapFactory.decodeResource(context.resources, R.mipmap.lightning4))
        Log.d(TAG, "prepareRes: total time: ${System.currentTimeMillis() - lastTime}")
        isPrepare = true
    }

    fun release() {
        rainBitmap?.recycle()
        rainBitmap = null
    }
}