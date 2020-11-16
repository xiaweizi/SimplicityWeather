package com.example.flutter_dynamic_weather.map

import android.animation.ValueAnimator
import android.content.Context
import android.graphics.*
import android.util.AttributeSet
import android.util.Log
import android.view.View
import android.view.animation.AccelerateInterpolator
import android.view.animation.LinearInterpolator
import com.example.flutter_dynamic_weather.R

/**
 * <pre>
 *     author : xiaweizi
 *     class  : com.example.flutter_dynamic_weather.map.MinuteChartView
 *     e-mail : 1012126908@qq.com
 *     time   : 2020/11/15
 *     desc   :
 * </pre>
 */
class MinuteChartView : View {

    private val mPaint = Paint(Paint.ANTI_ALIAS_FLAG)
    private val mTextPaint = Paint(Paint.ANTI_ALIAS_FLAG)
    private val mPath = Path()
    private val mBgPath = Path()
    private var mGradient: LinearGradient? = null
    private val mTop by lazy {
        context.resources.getDimensionPixelOffset(R.dimen.minute_chart_margin_top_bottom)
    }
    private val mAxisStart by lazy {
        context.resources.getDimensionPixelOffset(R.dimen.minute_chart_axis_margin_start)
    }
    private val mLineStart by lazy {
        context.resources.getDimensionPixelOffset(R.dimen.minute_chart_line_margin_start)
    }
    private val mTextSize by lazy {
        context.resources.getDimensionPixelOffset(R.dimen.minute_chart_text_size)
    }
    private val mTextColor by lazy {
        context.resources.getColor(R.color.public_sub_text_color)
    }
    private val mStartColor by lazy {
        context.resources.getColor(R.color.amap_chart_line_bg_start)
    }
    private val mEndColor by lazy {
        context.resources.getColor(R.color.amap_chart_line_bg_end)
    }
    private val mAxisColor by lazy {
        context.resources.getColor(R.color.amap_chart_axis_color)
    }
    private val mLineColor by lazy {
        context.resources.getColor(R.color.amap_chart_line_color)
    }
    private var mMinuteData: List<Float>? = null
    private var mMaxValue: Float = 0f
    private var mAnimator: ValueAnimator? = null
    private var mRatio = 1.0f

    constructor(context: Context?) : this(context, null)
    constructor(context: Context?, attrs: AttributeSet?) : this(context, attrs, -1)
    constructor(context: Context?, attrs: AttributeSet?, defStyleAttr: Int) : super(context, attrs, defStyleAttr) {

    }

    private fun startAnimator() {
        if (mAnimator == null) {
            mAnimator = ValueAnimator.ofFloat(0f, 1f).apply {
                duration = 800
                interpolator = LinearInterpolator()
                addUpdateListener {
                    mRatio = it.animatedValue as Float
                    invalidate()
                }
            }
        } else {
            mAnimator?.setFloatValues(0f, 1f)
        }
        mAnimator?.start()
    }

    fun setData(precipitation2h: List<Double>) {
        if (precipitation2h.isNotEmpty()) {
            val axisItemHeight = (height - mTop * 2) * 1.0f / 4
            mMinuteData = precipitation2h.map {
                val minuteY: Float = if (it <= 0.031) {
                    axisItemHeight * 0.02f
                } else if (it > 0.031 && it <= 0.25) {
                    axisItemHeight * (it.toFloat() - 0.031f) / (0.25f - 0.031f)
                } else if (it > 0.25 && it <= 0.35) {
                    axisItemHeight - axisItemHeight * (it.toFloat() - 0.25f) / 0.1f
                } else if (it > 0.35 && it <= 0.48) {
                    axisItemHeight * 2 - axisItemHeight * (it.toFloat() - 0.35f) / 0.13f
                } else {
                    axisItemHeight * 3 - axisItemHeight * (it.toFloat() - 0.48f) / 0.52f
                }
                if (minuteY > mMaxValue) {
                    mMaxValue = minuteY
                }
                minuteY
            }
            if (mMinuteData.isNullOrEmpty()) {
                postDelayed({
                    startAnimator()
                }, 300)
            } else {
                startAnimator()
            }
        }
    }

    override fun onDraw(canvas: Canvas?) {
        super.onDraw(canvas)
        if (!mMinuteData.isNullOrEmpty()) {
            val startY = height - mTop * 1.0f
            if (mGradient == null) {
                mGradient = LinearGradient(0f, mMaxValue, 0f, startY,
                        intArrayOf(mStartColor, mEndColor), null, Shader.TileMode.CLAMP)
            }
            mPath.reset()
            mBgPath.reset()
            val itemWidth = (width - mAxisStart * 2 - mLineStart) * 1.0f / 120
            mMinuteData!!.forEachIndexed { index, y ->
                val x = mAxisStart + mLineStart + itemWidth * index
                val y = startY - y * mRatio
                when (index) {
                    0 -> {
                        mPath.moveTo(x, y)
                        mBgPath.moveTo(x, startY)
                        mBgPath.lineTo(x, y)
                    }
                    in 1 until mMinuteData!!.size - 1 -> {
                        mPath.lineTo(x, y)
                        mBgPath.lineTo(x, y)
                    }
                    else -> {
                        mPath.lineTo(x, y)
                        mBgPath.lineTo(x, y)
                        mBgPath.lineTo(x, startY)
                        mBgPath.close()
                    }
                }
            }
            mPaint.color = mLineColor
            mPaint.strokeWidth = 3f
            mPaint.style = Paint.Style.STROKE
            mPaint.shader = null
            canvas?.drawPath(mPath, mPaint)

            mPaint.style = Paint.Style.FILL
            mPaint.shader = mGradient
            canvas?.drawPath(mBgPath, mPaint)
        }
        drawAxis(canvas)
    }

    private fun drawAxis(canvas: Canvas?) {
        val axisItemHeight = (height - mTop * 2) * 1.0f / 4
        val startX = mAxisStart.toFloat()
        val endX = width * 1.0f - mAxisStart
        var axisY: Float
        for (i in 0..4) {
            axisY = mTop + i * axisItemHeight
            mPaint.style = Paint.Style.STROKE
            mPaint.strokeWidth = 1f
            mPaint.color = mAxisColor
            mPaint.shader = null
            canvas?.drawLine(startX, axisY, endX, axisY, mPaint)
        }
        // 绘制 y 轴文字
        mTextPaint.textSize = mTextSize.toFloat()
        mTextPaint.textAlign = Paint.Align.CENTER
        mTextPaint.color = mTextColor
        val textX = mAxisStart + mLineStart * 1.0f / 2
        var textY = mTop + axisItemHeight / 2
        canvas?.drawText("暴雨", textX, textY, mTextPaint)
        textY = mTop + axisItemHeight / 2 + axisItemHeight
        canvas?.drawText("大雨", textX, textY, mTextPaint)
        textY = mTop + axisItemHeight / 2 + axisItemHeight * 2
        canvas?.drawText("中雨", textX, textY, mTextPaint)
        textY = mTop + axisItemHeight / 2 + axisItemHeight * 3
        canvas?.drawText("小雨", textX, textY, mTextPaint)
    }
}