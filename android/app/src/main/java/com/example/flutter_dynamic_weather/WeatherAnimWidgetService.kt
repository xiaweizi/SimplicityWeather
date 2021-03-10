package com.example.flutter_dynamic_weather

import android.app.Service
import android.content.Intent
import android.os.IBinder

class WeatherAnimWidgetService : Service() {

    override fun onBind(intent: Intent): IBinder {
        return null
    }
}