package com.example.flutter_dynamic_weather.base

import android.content.Context
import android.content.res.Configuration
import android.os.Build
import android.os.Bundle
import android.view.Gravity
import android.view.View
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity

/**
 * <pre>
 *     author : xiaweizi
 *     class  : com.example.flutter_dynamic_weather.base.BaseActivity
 *     e-mail : 1012126908@qq.com
 *     time   : 2020/10/15
 *     desc   :
 * </pre>
 */
abstract class BaseActivity : AppCompatActivity(), BaseCallback {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(getLayoutId())
        initView()
        initData()
    }

    /**
     * 是否可以使用沉浸式
     * Is immersion bar enabled boolean.
     *
     * @return the boolean
     */
    protected open fun isImmersionBarEnabled(): Boolean {
        return true
    }


    override fun onConfigurationChanged(newConfig: Configuration) {
        super.onConfigurationChanged(newConfig)

    }

    override fun initView() {

    }

    override fun initData() {

    }

    private var toast: Toast? = null

    open fun showToastCenter(context: Context?, msg: String?) {
        if (toast != null) {
            toast!!.cancel()
            toast = null
        }
        toast = Toast.makeText(context, "", Toast.LENGTH_SHORT) //如果有居中显示需求
        toast?.setGravity(Gravity.CENTER, 0, 0)
        toast?.setText(msg)
        toast?.show()
    }
}