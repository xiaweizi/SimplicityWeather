package com.example.flutter_dynamic_weather.map

/**
 * <pre>
 *     author : xiaweizi
 *     class  : com.example.flutter_dynamic_weather.map.MinuteData
 *     e-mail : 1012126908@qq.com
 *     time   : 2020/11/15
 *     desc   :
 * </pre>
 */
data class WeatherAllData(
        val minuteDesc: String,
        val precipitation2h: List<Double>,
        val weatherDesc: String,
        val temp: String,
        val aqiDesc: String,
        val updateTimeDesc: String,
)