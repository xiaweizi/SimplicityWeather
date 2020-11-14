package com.example.flutter_dynamic_weather.base

import android.content.res.Resources
import android.util.DisplayMetrics
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.FragmentActivity

/**
 * <pre>
 *     author : xiaweizi
 *     class  : com.eiffelyk.weather.weizi.middle.util.UiUtils
 *     e-mail : 1012126908@qq.com
 *     time   : 2020/10/17
 *     desc   :
 * </pre>
 */
class UiUtils {
    companion object {
        fun getStatusBarHeight(): Int {
            val resources = Resources.getSystem()
            val resourceId = resources.getIdentifier("status_bar_height", "dimen", "android")
            return resources.getDimensionPixelOffset(resourceId)
        }

        fun getScreenHeight(context: FragmentActivity): Int {
            val outMetrics = DisplayMetrics()
            context.windowManager.defaultDisplay.getMetrics(outMetrics)
            return outMetrics.heightPixels
        }

        fun getScreenWidth(context: FragmentActivity): Int {
            val outMetrics = DisplayMetrics()
            context.windowManager.defaultDisplay.getRealMetrics(outMetrics)
            return outMetrics.widthPixels
        }
    }
}