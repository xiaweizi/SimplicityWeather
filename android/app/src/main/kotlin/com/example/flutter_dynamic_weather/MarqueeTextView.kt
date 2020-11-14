package com.example.flutter_dynamic_weather

import android.content.Context
import android.util.AttributeSet
import android.widget.TextView

/**
 * <pre>
 *     author : xiaweizi
 *     class  : com.eiffelyk.weather.weizi.middle.view.MarqueeTextView
 *     e-mail : 1012126908@qq.com
 *     time   : 2020/11/02
 *     desc   :
 * </pre>
 */
class MarqueeTextView : androidx.appcompat.widget.AppCompatTextView {
    constructor(context: Context) : super(context)
    constructor(context: Context, attrs: AttributeSet?) : super(context, attrs)
    constructor(context: Context, attrs: AttributeSet?, defStyleAttr: Int) : super(
        context,
        attrs,
        defStyleAttr
    )

    override fun isFocused(): Boolean {
        return true
    }
}