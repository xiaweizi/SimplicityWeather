package com.example.flutter_dynamic_weather.base

/**
 * <pre>
 *     author ,xiaweizi
 *     class  ,com.example.flutter_dynamic_weather.base.WeatherUtils
 *     e-mail ,1012126908@qq.com
 *     time   ,2020/11/15
 *     desc   :
 * </pre>
 */
class WeatherUtils {
    companion object {
        val weatherMap = hashMapOf(
                Pair("CLEAR_DAY", "晴"),
                Pair("CLEAR_NIGHT", "晴"),
                Pair("PARTLY_CLOUDY_DAY", "多云"),
                Pair("PARTLY_CLOUDY_NIGHT", "多云"),
                Pair("CLOUDY", "阴"),
                Pair("LIGHT_HAZE", "霾"),
                Pair("MODERATE_HAZE", "霾"),
                Pair("HEAVY_HAZE", "霾"),
                Pair("LIGHT_RAIN", "小雨"),
                Pair("MODERATE_RAIN", "中雨"),
                Pair("HEAVY_RAIN", "大雨"),
                Pair("STORM_RAIN", "暴雨"),
                Pair("FOG", "雾"),
                Pair("LIGHT_SNOW", "小雪"),
                Pair("MODERATE_SNOW", "中雪"),
                Pair("HEAVY_SNOW", "大雪"),
                Pair("STORM_SNOW", "暴雪"),
                Pair("DUST", "浮尘"),
                Pair("SAND", "沙尘"),
                Pair("WIND", "大风"),
        )

        fun getWeatherDesc(type: String): String? {
            return weatherMap[type]
        }

        fun getAqiDesc(aqi: Int): String? {
            if (aqi in 0..50) {
                return "优"
            }
            if (aqi in 51..100) {
                return "良"
            }
            if (aqi in 101..150) {
                return "轻度污染"
            }
            if (aqi in 151..200) {
                return "中度污染"
            }
            if (aqi in 201..300) {
                return "重度污染"
            }
            return if (aqi > 300) {
                "严重污染"
            } else ""
        }
    }
}