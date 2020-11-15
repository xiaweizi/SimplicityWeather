package com.example.flutter_dynamic_weather.map

import com.google.gson.annotations.SerializedName


/**
 * <pre>
 *     author : xiaweizi
 *     class  : com.example.flutter_dynamic_weather.map.RealtimeResponse
 *     e-mail : 1012126908@qq.com
 *     time   : 2020/11/15
 *     desc   :
 * </pre>
 */
data class RealtimeResponse(
        @SerializedName("api_status")
        val apiStatus: String, // active
        @SerializedName("api_version")
        val apiVersion: String, // v2.5
        @SerializedName("lang")
        val lang: String, // zh_CN
        @SerializedName("location")
        val location: List<Double>,
        @SerializedName("result")
        val result: Result1,
        @SerializedName("server_time")
        val serverTime: Int, // 1605417973
        @SerializedName("status")
        val status: String, // ok
        @SerializedName("timezone")
        val timezone: String, // Asia/Taipei
        @SerializedName("tzshift")
        val tzshift: Int, // 28800
        @SerializedName("unit")
        val unit: String // metric
)

data class Result1(
        @SerializedName("primary")
        val primary: Int, // 0
        @SerializedName("realtime")
        val realtime: Realtime
)

data class Realtime(
        @SerializedName("air_quality")
        val airQuality: AirQuality,
        @SerializedName("apparent_temperature")
        val apparentTemperature: Double, // 17.4
        @SerializedName("cloudrate")
        val cloudrate: Int, // 0
        @SerializedName("dswrf")
        val dswrf: Double, // 551.6
        @SerializedName("humidity")
        val humidity: Double, // 0.58
        @SerializedName("life_index")
        val lifeIndex: LifeIndex,
        @SerializedName("precipitation")
        val precipitation: Precipitation,
        @SerializedName("pressure")
        val pressure: Double, // 100205.89
        @SerializedName("skycon")
        val skycon: String, // WIND
        @SerializedName("status")
        val status: String, // ok
        @SerializedName("temperature")
        val temperature: Double, // 22.16
        @SerializedName("visibility")
        val visibility: Double, // 11.19
        @SerializedName("wind")
        val wind: Wind
)

data class AirQuality(
        @SerializedName("aqi")
        val aqi: Aqi,
        @SerializedName("co")
        val co: Int, // 0
        @SerializedName("description")
        val description: Description,
        @SerializedName("no2")
        val no2: Int, // 0
        @SerializedName("o3")
        val o3: Int, // 0
        @SerializedName("pm10")
        val pm10: Int, // 0
        @SerializedName("pm25")
        val pm25: Int, // 6
        @SerializedName("so2")
        val so2: Int // 0
)

data class LifeIndex(
        @SerializedName("comfort")
        val comfort: Comfort,
        @SerializedName("ultraviolet")
        val ultraviolet: Ultraviolet
)

data class Precipitation(
        @SerializedName("local")
        val local: Local
)

data class Wind(
        @SerializedName("direction")
        val direction: Int, // 45
        @SerializedName("speed")
        val speed: Double // 33.48
)

data class Aqi(
        @SerializedName("chn")
        val chn: Int, // 13
        @SerializedName("usa")
        val usa: Int // 0
)

data class Description(
        @SerializedName("chn")
        val chn: String, // 优
        @SerializedName("usa")
        val usa: String
)

data class Comfort(
        @SerializedName("desc")
        val desc: String, // 凉爽
        @SerializedName("index")
        val index: Int // 6
)

data class Ultraviolet(
        @SerializedName("desc")
        val desc: String, // 强
        @SerializedName("index")
        val index: Int // 7
)

data class Local(
        @SerializedName("datasource")
        val datasource: String, // gfs
        @SerializedName("intensity")
        val intensity: Int, // 0
        @SerializedName("status")
        val status: String // ok
)