package com.example.flutter_dynamic_weather.base

import com.jakewharton.retrofit2.adapter.kotlin.coroutines.CoroutineCallAdapterFactory
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory


/**
 * <pre>
 *     author : xiaweizi
 *     class  : com.eiffelyk.weather.weizi.main.net.ApiManager
 *     e-mail : 1012126908@qq.com
 *     time   : 2020/10/16
 *     desc   :
 * </pre>
 */
class ApiManager private constructor() {
    private val retrofit: Retrofit = Retrofit.Builder().apply {
        val logging = HttpLoggingInterceptor()
        logging.setLevel(HttpLoggingInterceptor.Level.BODY)
        val httpClient = OkHttpClient.Builder()
        httpClient.addInterceptor(logging)
        client(httpClient.build())
        baseUrl(BaseConstant.BASE_URL)
        addConverterFactory(GsonConverterFactory.create())
        addCallAdapterFactory(CoroutineCallAdapterFactory.invoke())
    }.build()

    fun <T> createService(clazz: Class<T>): T {
        return retrofit.create(clazz)
    }

    companion object {
        val instance by lazy {
            ApiManager()
        }
    }
}