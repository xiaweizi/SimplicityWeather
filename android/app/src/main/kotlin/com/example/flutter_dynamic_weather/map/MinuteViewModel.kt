package com.eiffelyk.weather.weizi.map

import android.content.Context
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.bumptech.glide.Glide
import com.example.flutter_dynamic_weather.base.ApiManager
import com.example.flutter_dynamic_weather.base.LogUtils
import com.example.flutter_dynamic_weather.base.WeatherUtils
import com.example.flutter_dynamic_weather.map.MinuteResponse
import com.example.flutter_dynamic_weather.map.MinuteService
import com.example.flutter_dynamic_weather.map.RealtimeResponse
import com.example.flutter_dynamic_weather.map.WeatherAllData
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import okhttp3.ResponseBody
import org.json.JSONObject
import retrofit2.Call
import java.text.SimpleDateFormat
import java.util.*

/**
 * <pre>
 *     author : xiaweizi
 *     class  : com.eiffelyk.weather.weizi.map.MinuteViewModel
 *     e-mail : 1012126908@qq.com
 *     time   : 2020/11/08
 *     desc   :
 * </pre>
 */
class MinuteViewModel : ViewModel() {

    companion object {
        private const val TAG = "Minute-ViewModel"
    }

    private val mService: MinuteService by lazy {
        ApiManager.instance.createService(MinuteService::class.java)
    }

    private fun fetchData(): Call<ResponseBody>? {
        try {
            return mService.getForecastImages("116.427301", "39.902451")
        } catch (e: Exception) {
            LogUtils.i(TAG, "fetchData error: ${e.message}")
        }
        return null
    }

    private fun getMinuteData(lat: String, long: String): MinuteResponse? {
        try {
            return mService.getMinutely(long, lat).execute().body()
        } catch (e: Exception) {
            LogUtils.i(TAG, "getMinuteData error: ${e.message}")
        }
        return null
    }

    private fun getRealtimeData(lat: String, long: String): RealtimeResponse? {
        try {
            return mService.getRealtime(long, lat).execute().body()
        } catch (e: Exception) {
            LogUtils.i(TAG, "getMinuteData error: ${e.message}")
        }
        return null
    }

    fun getAllData(lat: String, long: String, callback: ((WeatherAllData?) -> Unit)?) {
        viewModelScope.launch(Dispatchers.IO) {
            val realtime = getRealtimeData(lat, long)
            val minuteData = getMinuteData(lat, long)
            if (realtime == null || minuteData == null) {
                callback?.invoke(null)
                return@launch
            }

            var minuteDesc = ""
            var precipitation2h: List<Double> = mutableListOf()
            var weatherDesc = ""
            var temp = ""
            var aqiDesc = ""
            var updateTimeDesc = ""
            var updateTime = 0L

            if (realtime != null) {
                val date = Date(realtime.serverTime * 1000L)
                val format = SimpleDateFormat("HH:mm")
                updateTimeDesc = format.format(date)
                updateTime = realtime.serverTime.toLong()

                weatherDesc = WeatherUtils.getWeatherDesc(realtime.result?.realtime?.skycon) ?: ""
                temp = realtime.result?.realtime?.temperature?.toInt()?.toString()
                aqiDesc = WeatherUtils.getAqiDesc(realtime?.result?.realtime?.airQuality?.aqi?.chn.toInt())
                        ?: ""
            }
            if (minuteData != null) {
                minuteDesc = minuteData.result?.forecastKeypoint
                precipitation2h = minuteData.result?.minutely?.precipitation2h
            }

            val allData = WeatherAllData(minuteDesc, precipitation2h, weatherDesc, temp, aqiDesc, updateTimeDesc, updateTime)
            callback?.invoke(allData)
        }
    }

    fun getForecastImages(context: Context, callback: ((List<RainData>?) -> Unit)? = null) {
        viewModelScope.launch(Dispatchers.IO) {
            val data = fetchData()?.execute()
            if (data != null) {
                val str = data.body()?.string()
                if (!str.isNullOrEmpty()) {
                    val minuteData = mutableListOf<RainData>()
                    try {
                        val jo = JSONObject(str)
                        val ja = jo.getJSONArray("images")
                        LogUtils.i(TAG, "ja length: ${ja.length()}")
                        for (i in IntRange(0, ja.length() - 1)) {
                            val jaa = ja.getJSONArray(i)
                            val jaaa = jaa.getJSONArray(2)
                            val url = jaa.getString(0)
                            val bitmap =
                                    Glide.with(context).asBitmap().load(url)
                                            .submit(500, 500).get()
                            val data = RainData(
                                    jaaa.getDouble(0),
                                    jaaa.getDouble(1),
                                    jaaa.getDouble(2),
                                    jaaa.getDouble(3),
                                    bitmap,
                                    jaa.getString(0),
                                    jaa.getString(1),
                            )
                            minuteData.add(data)
                        }
                        callback?.invoke(minuteData)
                    } catch (e: Exception) {
                        LogUtils.i(TAG, "getForecastImages: ${e.message}")
                        callback?.invoke(null)
                    }
                    LogUtils.i(TAG, "getForecastImages: size: ${minuteData.size}")
                } else {
                    callback?.invoke(null)
                }
            }
        }
    }
}