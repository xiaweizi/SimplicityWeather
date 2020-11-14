package com.example.flutter_dynamic_weather.base

import android.content.Intent
import android.os.Bundle
import android.text.TextUtils
import android.view.KeyEvent
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import com.umeng.analytics.MobclickAgent


/**
 * <pre>
 *     author : xiaweizi
 *     class  : com.example.flutter_dynamic_weather.base.BaseFragment
 *     e-mail : 1012126908@qq.com
 *     time   : 2020/10/15
 *     desc   :
 * </pre>
 */
abstract class BaseFragment : Fragment(), BaseCallback {

    private lateinit var mRootView: View

    override fun onCreateView(
            inflater: LayoutInflater,
            container: ViewGroup?,
            savedInstanceState: Bundle?
    ): View? {
        mRootView = inflater.inflate(getLayoutId(), container, false)
        return mRootView
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        initView()
        initData()
    }


    override fun initView() {
    }

    override fun initData() {
    }

    fun finish() {
        if (activity != null && !activity!!.isFinishing) {
            activity?.finish()
        }
    }

    open fun onKeyDown(keyCode: Int, event: KeyEvent?): Boolean {
        return false
    }

    open fun onBackPressed(): Boolean {
        return false
    }

    open fun onNewIntent(intent: Intent?) {
    }

    // Fragment页面onResume函数重载
    override fun onResume() {
        super.onResume()
        MobclickAgent.onPageStart(this.javaClass.simpleName)
    }

    // Fragment页面onResume函数重载
    override fun onPause() {
        super.onPause()
        MobclickAgent.onPageEnd(this.javaClass.simpleName)
    }

    protected open fun showToast(message: String?) {
        if (!TextUtils.isEmpty(message)) {
            Toast.makeText(context, message, Toast.LENGTH_SHORT).show()
        }
    }

}