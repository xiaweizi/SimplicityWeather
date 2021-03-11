package com.example.flutter_dynamic_weather

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.graphics.Bitmap
import android.util.Log
import android.widget.RemoteViews

/**
 * Implementation of App Widget functionality.
 */
class WeatherAnimWidget : AppWidgetProvider() {

    companion object {
        private const val TAG = "WeatherService-widget::"
        internal fun updateAppWidget(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int, bitmap: Bitmap? = null) {
            val views = RemoteViews(context.packageName, R.layout.weather_anim_widget)
            if (bitmap != null) {
                views.setImageViewBitmap(R.id.appwidget_bg, bitmap)
            }
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onEnabled(context: Context) {
        WeatherAnimWidgetService.startService(context)
    }

    override fun onDisabled(context: Context) {

    }
}

