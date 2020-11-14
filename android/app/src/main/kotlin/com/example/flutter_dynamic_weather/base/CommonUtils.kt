package com.example.flutter_dynamic_weather.base

import android.app.ActivityManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.location.LocationManager
import android.net.Uri
import androidx.core.content.ContextCompat.startActivity
import com.eiffelyk.weather.weizi.map.MinuteFragment


/**
 * <pre>
 *     author : xiaweizi
 *     class  : com.eiffelyk.weather.weizi.middle.util.CommonUtils
 *     e-mail : 1012126908@qq.com
 *     time   : 2020/10/21
 *     desc   :
 * </pre>
 */

fun Intent.putParams(params: HashMap<String, String>) {
    params.forEach {
        this.putExtra(it.key, it.value)
    }
}

class CommonUtils {
    companion object {
        private const val TAG = "CommonUtils::"

        private fun startModuleActivity(
                context: Context,
                fragmentName: String,
                handleIntent: ((Intent) -> Unit)? = null
        ) {
            LogUtils.i(TAG, "startModuleActivity: $fragmentName")
            try {
                val intent = Intent(context, ModuleActivity::class.java)
                intent.putExtra(BaseConstant.FRAGMENT_NAME, fragmentName)
                handleIntent?.invoke(intent)
                startActivity(context, intent, null)
            } catch (e: Exception) {
                LogUtils.i(TAG, "startModuleActivity error ${e.message}")
            }
        }

        fun startMinutePage(context: Context, handleIntent: ((Intent) -> Unit)? = null) {
            startModuleActivity(context, MinuteFragment::class.java.name, handleIntent)
        }

    }
}