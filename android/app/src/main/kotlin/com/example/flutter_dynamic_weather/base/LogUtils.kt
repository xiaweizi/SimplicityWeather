package com.example.flutter_dynamic_weather.base

import android.util.Log

/**
 * <pre>
 *     author : xiaweizi
 *     class  : com.eiffelyk.weather.weizi.middle.util.LogUtils
 *     e-mail : 1012126908@qq.com
 *     time   : 2020/10/19
 *     desc   : 日志工具类
 * </pre>
 */
class LogUtils {
    companion object {
        fun i(tag: String, content: String) {
            Log.i("Weather-$tag", content)
        }
    }
}