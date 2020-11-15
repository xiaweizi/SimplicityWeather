package com.example.flutter_dynamic_weather.map

import okhttp3.ResponseBody
import retrofit2.Call
import retrofit2.http.GET
import retrofit2.http.Path
import retrofit2.http.Query

/**
 * <pre>
 *     author : xiaweizi
 *     class  : com.example.flutter_dynamic_weather.map.MinuteService
 *     e-mail : 1012126908@qq.com
 *     time   : 2020/11/08
 *     desc   :
 * </pre>
 */
interface MinuteService {

    @GET("/v1/radar/forecast_images?level=2&token=leWWGdduHOh6bAkw")
    fun getForecastImages(@Query("lon") lon: String, @Query("lat") lat: String): Call<ResponseBody>

    @GET("/v2.5/leWWGdduHOh6bAkw/{lon},{lat}/minutely.json")
    fun getMinutely(@Path("lon") lon: String, @Path("lat") lat: String): Call<MinuteResponse>

    @GET("/v2.5/leWWGdduHOh6bAkw/{lon},{lat}/realtime.json")
    fun getRealtime(@Path("lon") lon: String, @Path("lat") lat: String): Call<RealtimeResponse>
}