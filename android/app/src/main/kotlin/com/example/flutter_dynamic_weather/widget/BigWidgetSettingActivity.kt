package com.example.flutter_dynamic_weather.widget

import android.app.Activity
import android.appwidget.AppWidgetManager
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.RemoteViews
import com.example.flutter_dynamic_weather.R
import com.example.flutter_dynamic_weather.base.BaseActivity

class BigWidgetSettingActivity : BaseActivity() {

    private var appWidgetId: Int = AppWidgetManager.INVALID_APPWIDGET_ID
    override fun initView() {
        super.initView()
        appWidgetId = intent?.extras?.getInt(
                AppWidgetManager.EXTRA_APPWIDGET_ID,
                AppWidgetManager.INVALID_APPWIDGET_ID
        ) ?: AppWidgetManager.INVALID_APPWIDGET_ID
//        onCancelConfig()
    }

    override fun getLayoutId() = R.layout.activity_big_widget_setting

    override fun onBackPressed() {
        onCompleteConfig()
    }

    private fun onCompleteConfig() {
        val appWidgetManager: AppWidgetManager = AppWidgetManager.getInstance(this)
        RemoteViews(packageName, R.layout.layout_widget_big).also { views->
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
        val resultValue = Intent().apply {
            putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
        }
        setResult(Activity.RESULT_OK, resultValue)
        finish()
    }

    private fun onCancelConfig() {
        val resultValue = Intent().apply {
            putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
        }
        setResult(Activity.RESULT_CANCELED, resultValue)
    }

}