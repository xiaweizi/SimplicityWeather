package com.eiffelyk.weather.weizi.map

import android.annotation.SuppressLint
import android.content.Context
import android.graphics.*
import android.util.AttributeSet
import android.view.MotionEvent
import android.view.View
import com.example.flutter_dynamic_weather.R
import kotlin.math.max
import kotlin.math.min

/**
 * <pre>
 *     author : xiaweizi
 *     class  : com.eiffelyk.weather.weizi.map.MinuteProgressView
 *     e-mail : 1012126908@qq.com
 *     time   : 2020/11/08
 *     desc   :
 * </pre>
 */
class MinuteProgressView : View {
    private val mStartColor by lazy {
        resources.getColor(R.color.amap_progress_bg_start_color)
    }
    private val mEndColor by lazy {
        resources.getColor(R.color.amap_progress_bg_end_color)
    }
    private val mPaint = Paint(Paint.ANTI_ALIAS_FLAG)
    private val mRectF = RectF()

    private var mLinearGradient: LinearGradient? = null
    private var mRatio = 0.0f
    private var mCallback: OnProgressCallback? = null
    private var mIsPlaying = false

    constructor(context: Context?) : this(context, null)
    constructor(context: Context?, attrs: AttributeSet?) : this(context, attrs, -1)
    constructor(context: Context?, attrs: AttributeSet?, defStyleAttr: Int) : super(
        context,
        attrs,
        defStyleAttr
    )

    fun setProgressCallback(callback: OnProgressCallback?) {
        this.mCallback = callback
    }

    fun setRatio(ratio: Float) {
        mRatio = ratio
        invalidate()
    }

    override fun onDraw(canvas: Canvas?) {
        super.onDraw(canvas)
        if (mLinearGradient == null) {
            mLinearGradient = LinearGradient(
                0f,
                0f,
                width.toFloat(),
                height.toFloat(),
                intArrayOf(mStartColor, mEndColor),
                null,
                Shader.TileMode.CLAMP
            )
            mPaint.shader = mLinearGradient
        }
        mRectF.set(0f, 0f, width.toFloat() * mRatio, height.toFloat())
        canvas?.drawRect(mRectF, mPaint)
    }

    @SuppressLint("ClickableViewAccessibility")
    override fun onTouchEvent(event: MotionEvent?): Boolean {
        if (event != null && mCallback != null) {
            val x = event.x
            when (event.actionMasked) {
                MotionEvent.ACTION_DOWN -> {
                    mRatio = min(width.toFloat(), max(0f, x)) / width
                    invalidate()
                    mIsPlaying = mCallback?.onDown(mRatio) ?: false
                }
                MotionEvent.ACTION_MOVE -> {
                    mRatio = min(width.toFloat(), max(0f, x)) / width
                    invalidate()
                    mCallback?.onMove(mRatio)
                }
                MotionEvent.ACTION_UP -> {
                    mCallback?.onUp(mIsPlaying)
                }

            }
        }
        return true
    }

    interface OnProgressCallback {
        fun onDown(ratio: Float): Boolean
        fun onMove(ratio: Float)
        fun onUp(isPlaying: Boolean)
    }
}