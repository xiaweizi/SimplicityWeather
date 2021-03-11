package com.example.flutter_dynamic_weather

import android.graphics.Bitmap
import android.graphics.Point
import android.view.animation.AccelerateInterpolator
import android.view.animation.DecelerateInterpolator
import java.util.*
import kotlin.math.abs

/**
 * <pre>
 *     class  : com.example.flutter_dynamic_weather.RainParam
 *     time   : 2021/03/10
 *     desc   :
 * </pre>
 */
data class ThunderParam(
        var x: Float = 0f,
        var y: Float = 0f,
        var alpha: Float = 1f,
        var progress: Float = 0f, // 0-1 show 9-10 hide
        var show: Boolean = true,
        var bitmap: Bitmap = WeatherResFactory.instance.rainBitmap!!,
        var point: Point
) {

    init {
        val index = (Random().nextFloat() * 4).toInt()
        bitmap = WeatherResFactory.instance.thunderBitmap[index]!!
        x = (point.x / 2f + bitmap.width / 2f) * Random().nextFloat() - bitmap.width / 2f
        y = 1f / 5 * bitmap.height * Random().nextFloat() - bitmap.height * 1f / 5
        progress = 12f * Random().nextFloat()
        alpha = when {
            abs(progress) in 0f..1.0f -> {
                progress
            }
            abs(progress) in 1.0f..2.0f -> {
                2.0f - progress
            }
            else -> {
                0f
            }
        }
    }


    fun move() {
        progress += 0.1f
        if (progress >= 12f) {
            progress = 0.0f
        }
        alpha = when {
            abs(progress) in 0f..1.0f -> {
                AccelerateInterpolator().getInterpolation(progress)
            }
            abs(progress) in 1.0f..2.0f -> {
                DecelerateInterpolator().getInterpolation(2.0f - progress)
            }
            else -> {
                0f
            }
        }
    }
}