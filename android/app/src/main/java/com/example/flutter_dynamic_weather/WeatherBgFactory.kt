package com.example.flutter_dynamic_weather

import android.graphics.Bitmap

/**
 * <pre>
 *     class  : com.example.flutter_dynamic_weather.WeatherBgFactory
 *     time   : 2021/03/10
 *     desc   :
 * </pre>
 */
interface WeatherBgFactory {
    fun crate(): Bitmap
}