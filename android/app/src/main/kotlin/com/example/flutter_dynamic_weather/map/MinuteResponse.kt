package com.example.flutter_dynamic_weather.map

import com.google.gson.annotations.SerializedName


/**
 * <pre>
 *     author : xiaweizi
 *     class  : com.example.flutter_dynamic_weather.map.MinuteResponse
 *     e-mail : 1012126908@qq.com
 *     time   : 2020/11/15
 *     desc   :
 * </pre>
 */
data class MinuteResponse(
        @SerializedName("api_status")
        val apiStatus: String, // active
        @SerializedName("api_version")
        val apiVersion: String, // v2.5
        @SerializedName("lang")
        val lang: String, // zh_CN
        @SerializedName("location")
        val location: List<Double>,
        @SerializedName("result")
        val result: Result,
        @SerializedName("server_time")
        val serverTime: Int, // 1605416697
        @SerializedName("status")
        val status: String, // ok
        @SerializedName("timezone")
        val timezone: String, // Asia/Taipei
        @SerializedName("tzshift")
        val tzshift: Int, // 28800
        @SerializedName("unit")
        val unit: String // metric
)

data class Result(
        @SerializedName("forecast_keypoint")
        val forecastKeypoint: String, // 大风起兮……注意不要被风刮跑
        @SerializedName("minutely")
        val minutely: Minutely,
        @SerializedName("primary")
        val primary: Int // 0
)

data class Minutely(
        @SerializedName("datasource")
        val datasource: String, // gfs
        @SerializedName("description")
        val description: String, // 大风起兮……注意不要被风刮跑
        @SerializedName("precipitation")
        val precipitation: List<Double>,
        @SerializedName("precipitation_2h")
        val precipitation2h: List<Double>,
        @SerializedName("probability")
        val probability: List<Double>,
        @SerializedName("status")
        val status: String // ok
)