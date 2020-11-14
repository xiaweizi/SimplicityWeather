package com.example.flutter_dynamic_weather.base

import androidx.annotation.LayoutRes

/**
 * <pre>
 *     author : xiaweizi
 *     class  : com.example.flutter_dynamic_weather.interfaces.BaseCallback
 *     e-mail : 1012126908@qq.com
 *     time   : 2020/10/15
 *     desc   :
 * </pre>
 */
interface BaseCallback {
    @LayoutRes
    fun getLayoutId(): Int
    fun initView()
    fun initData()
}