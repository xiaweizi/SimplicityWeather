package com.eiffelyk.weather.weizi.map

import android.graphics.Bitmap

/**
 * <pre>
 *     author : xiaweizi
 *     class  : com.eiffelyk.weather.weizi.map.MinuteData
 *     e-mail : 1012126908@qq.com
 *     time   : 2020/11/08
 *     desc   :
 * </pre>
 */
data class MinuteData(
    var leftLat: Double,
    var leftLong: Double,
    var rightLat: Double,
    var rightLong: Double,
    var srcBitmap: Bitmap? = null,
    var srcUrl: String,
    var time: String,
)