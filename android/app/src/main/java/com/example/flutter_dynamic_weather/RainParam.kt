package com.example.flutter_dynamic_weather

import android.graphics.Bitmap
import android.graphics.Point
import java.util.*

/**
 * <pre>
 *     class  : com.example.flutter_dynamic_weather.RainParam
 *     time   : 2021/03/10
 *     desc   :
 * </pre>
 */
data class RainParam(
        var x: Float = 0f,
        var y: Float = 0f,
        var scale: Float = 1f,
        var alpha: Float = 1f,
        var speed: Float = 10.5f,
        var bitmap: Bitmap = WeatherResFactory.instance.rainBitmap!!,
        var point: Point,
) {

    init {
        scale = Random().nextFloat() * 0.5f + 0.5f
        x = (point.x + 2 * bitmap.width) * Random().nextFloat() - bitmap.width
        y = (point.y + 2 * bitmap.height) * Random().nextFloat() - bitmap.height
        x /= scale
        y /= scale
        alpha *= scale * 0.2f + 0.8f
    }

    private fun reset() {
        scale = Random().nextFloat() * 0.1f + 0.9f
        x = (point.x + 2 * bitmap.width) * Random().nextFloat() - bitmap.width
        y = (-bitmap.height).toFloat()
        x /= scale
        alpha = scale * 0.8f + 0.2f
    }

    fun move(point: Point = this.point) {
        y += speed
        if (y > point.y + bitmap.height) {
            reset()
        }
    }
}