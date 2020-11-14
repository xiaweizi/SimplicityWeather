package com.example.flutter_dynamic_weather.base

/**
 * <pre>
 *     author : xiaweizi
 *     class  : com.example.flutter_dynamic_weather.base.ModuleActivity
 *     e-mail : 1012126908@qq.com
 *     time   : 2020/10/21
 *     desc   :
 * </pre>
 */
class ModuleActivity: BaseFragmentActivity() {

    override fun getFragment(): BaseFragment? {
        return newInsFragment()
    }

    private fun newInsFragment(): BaseFragment? {
        if (mFragment == null) {
            try {
                val fragmentName = intent.getStringExtra(BaseConstant.FRAGMENT_NAME)
                val onwClass = Class.forName(fragmentName!!)
                val instance = onwClass.newInstance()
                mFragment = instance as BaseFragment
            } catch (e: Throwable) {
                e.printStackTrace()
            }
        }
        return mFragment
    }
}