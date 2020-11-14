package com.example.flutter_dynamic_weather.base

import android.content.Intent
import android.view.KeyEvent
import com.example.flutter_dynamic_weather.R

/**
 * <pre>
 *     author : xiaweizi
 *     class  : com.example.flutter_dynamic_weather.base.BaseFragmentActivity
 *     e-mail : 1012126908@qq.com
 *     time   : 2020/10/15
 *     desc   :
 * </pre>
 */
abstract class BaseFragmentActivity : BaseActivity() {
    var mFragment: BaseFragment? = null
    override fun getLayoutId() = R.layout.layout_public_activity
    override fun initView() {
        super.initView()
        // 初始化 fragment
        mFragment = getFragment()
        if (mFragment != null) {
            val beginTransaction = supportFragmentManager.beginTransaction()
            beginTransaction.replace(R.id.fl_root, mFragment!!)
            beginTransaction.commitAllowingStateLoss()
        }
    }

    abstract fun getFragment(): BaseFragment?

    override fun onNewIntent(intent: Intent?) {
        super.onNewIntent(intent)
        mFragment?.onNewIntent(intent)
    }

    override fun onKeyDown(keyCode: Int, event: KeyEvent?): Boolean {
        if (mFragment != null) {
            if (!mFragment!!.onKeyDown(keyCode, event)) {
                return super.onKeyDown(keyCode, event)
            }
        }
        return super.onKeyDown(keyCode, event)
    }
}