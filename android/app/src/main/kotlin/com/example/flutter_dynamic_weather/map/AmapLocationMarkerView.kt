package com.example.flutter_dynamic_weather.map

import android.content.Context
import android.graphics.Canvas
import android.graphics.Paint
import android.util.AttributeSet
import android.view.View
import com.example.flutter_dynamic_weather.R

/**
 * <pre>
 *     author : xiaweizi
 *     class  : com.eiffelyk.weather.weizi.map.AmapLocationMarkerView
 *     e-mail : 1012126908@qq.com
 *     time   : 2020/11/08
 *     desc   :
 * </pre>
 */
class AmapLocationMarkerView : View {
    private var mOuterRadius = 0
    private var mInnerRadius = 0
    private var mPaint: Paint? = null
    private var mOuterColor = 0
    private var mInnerColor = 0

    constructor(context: Context?) : this(context, null)
    constructor(context: Context?, attrs: AttributeSet?) : this(context, attrs, -1)
    constructor(context: Context?, attrs: AttributeSet?, defStyleAttr: Int) : super(
        context,
        attrs,
        defStyleAttr
    ) {
        initView(context!!)
    }


    private fun initView(context: Context) {
        mOuterRadius =
            resources.getDimensionPixelSize(R.dimen.amap_marker_view_located_outer_radius)
        mInnerRadius =
            resources.getDimensionPixelSize(R.dimen.amap_marker_view_located_inner_radius)
        mOuterColor = resources.getColor(R.color.amap_marker_view_located_outer_color)
        mInnerColor = resources.getColor(R.color.amap_marker_view_located_inner_color)
        mPaint = Paint(Paint.ANTI_ALIAS_FLAG)
        mPaint!!.style = Paint.Style.FILL
    }

    override fun onMeasure(widthMeasureSpec: Int, heightMeasureSpec: Int) {
        super.onMeasure(widthMeasureSpec, heightMeasureSpec)
        setMeasuredDimension(mOuterRadius * 2, mOuterRadius * 2)
    }

    override fun onDraw(canvas: Canvas) {
        super.onDraw(canvas)
        mPaint!!.color = mOuterColor
        canvas.drawCircle(
            width / 2.toFloat(), height / 2.toFloat(), mOuterRadius.toFloat(),
            mPaint!!
        )
        mPaint!!.color = mInnerColor
        canvas.drawCircle(
            width / 2.toFloat(), height / 2.toFloat(), mInnerRadius.toFloat(),
            mPaint!!
        )
    }
}