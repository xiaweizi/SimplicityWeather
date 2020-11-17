package com.example.flutter_dynamic_weather.widget

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.widget.RemoteViews
import com.example.flutter_dynamic_weather.R

/**
 * <pre>
 *     author : xiaweizi
 *     class  : com.example.flutter_dynamic_weather.widget.BigWidgetProvider
 *     e-mail : 1012126908@qq.com
 *     time   : 2020/11/16
 *     desc   :
 * </pre>
 */
class BigWidgetProvider : AppWidgetProvider() {
    companion object {
        private const val TAG = "BigWidgetProvider::"
    }

    private val mIdSet = hashSetOf<Int>()
    private val mHandler = Handler(Looper.getMainLooper())

    override fun onReceive(context: Context?, intent: Intent?) {
        super.onReceive(context, intent)
        val value = intent?.getIntExtra("value", 1) ?: 1
        val ids = intent?.getStringExtra("ids")
        if (!ids.isNullOrEmpty()) {
            ids.split(",").forEach {
                val value = it.toIntOrNull() ?: -1
                if (value != -1) {
                    mIdSet.add(value)
                }
            }
        }
        Log.d(TAG, "onReceive: ${intent?.getStringExtra("haha")}")
        Log.d(TAG, "onReceive: action: ${intent?.action}, hashCode: ${hashCode()}, value: $value, set: $mIdSet")
        updateAllWidget(context, AppWidgetManager.getInstance(context), value)
    }

    private fun updateAllWidget(context: Context?, appWidgetManager: AppWidgetManager, value: Int) {
        if (context == null) {
            return
        }
        mIdSet.forEach {
            val remoteView = RemoteViews(context.packageName, R.layout.layout_widget_big)
            remoteView.setImageViewBitmap(R.id.iv_icon, createBitmap(value))
            appWidgetManager.updateAppWidget(it, remoteView)
        }
    }

    private fun createBitmap(value: Int): Bitmap {
        Log.w(TAG, "createBitmap: value: $value")
        val bitmap = Bitmap.createBitmap(300, 300, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(bitmap)
        val paint = Paint(Paint.ANTI_ALIAS_FLAG)
        val ratio = value * 1.0f / 300
        paint.color = getCurrentColor(ratio, Color.RED, Color.GREEN)
        canvas.drawCircle(0f + value, 0f + value * 0.5f, value * 0.4f, paint)
        return bitmap
    }

    private fun getCurrentColor(fraction: Float, startColor: Int, endColor: Int): Int {
        val redCurrent: Int
        val blueCurrent: Int
        val greenCurrent: Int
        val alphaCurrent: Int
        val redStart = Color.red(startColor)
        val blueStart = Color.blue(startColor)
        val greenStart = Color.green(startColor)
        val alphaStart = Color.alpha(startColor)
        val redEnd = Color.red(endColor)
        val blueEnd = Color.blue(endColor)
        val greenEnd = Color.green(endColor)
        val alphaEnd = Color.alpha(endColor)
        val redDifference = redEnd - redStart
        val blueDifference = blueEnd - blueStart
        val greenDifference = greenEnd - greenStart
        val alphaDifference = alphaEnd - alphaStart
        redCurrent = (redStart + fraction * redDifference).toInt()
        blueCurrent = (blueStart + fraction * blueDifference).toInt()
        greenCurrent = (greenStart + fraction * greenDifference).toInt()
        alphaCurrent = (alphaStart + fraction * alphaDifference).toInt()
        return Color.argb(alphaCurrent, redCurrent, greenCurrent, blueCurrent)
    }

    override fun onUpdate(context: Context?, appWidgetManager: AppWidgetManager?, appWidgetIds: IntArray?) {
        super.onUpdate(context, appWidgetManager, appWidgetIds)
        Log.d(TAG, "onUpdate: ")
        appWidgetIds?.forEach {
            mIdSet.add(it)
        }
    }

    override fun onAppWidgetOptionsChanged(context: Context?, appWidgetManager: AppWidgetManager?, appWidgetId: Int, newOptions: Bundle?) {
        super.onAppWidgetOptionsChanged(context, appWidgetManager, appWidgetId, newOptions)
        Log.d(TAG, "onAppWidgetOptionsChanged: ")
    }

    override fun onDeleted(context: Context?, appWidgetIds: IntArray?) {
        super.onDeleted(context, appWidgetIds)
        Log.d(TAG, "onDeleted: ")
        appWidgetIds?.forEach {
            mIdSet.remove(it)
        }
    }

    override fun onEnabled(context: Context?) {
        super.onEnabled(context)
        Log.d(TAG, "onEnabled: ")
    }

    override fun onDisabled(context: Context?) {
        super.onDisabled(context)
        Log.d(TAG, "onDisabled: ")
    }

    override fun onRestored(context: Context?, oldWidgetIds: IntArray?, newWidgetIds: IntArray?) {
        super.onRestored(context, oldWidgetIds, newWidgetIds)
        Log.d(TAG, "onRestored: ")
    }
}
