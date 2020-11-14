package com.eiffelyk.weather.weizi.map

import android.animation.ObjectAnimator
import android.content.Context
import android.graphics.*
import android.util.AttributeSet
import android.view.MotionEvent
import android.view.VelocityTracker
import android.view.View
import android.view.animation.AccelerateInterpolator
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.fragment.app.FragmentActivity
import com.example.flutter_dynamic_weather.R
import com.example.flutter_dynamic_weather.base.LogUtils
import com.example.flutter_dynamic_weather.base.UiUtils
import kotlinx.android.synthetic.main.layout_minute_progress.view.*
import kotlin.math.abs
import kotlin.math.max
import kotlin.math.min

/**
 * <pre>
 *     author : xiaweizi
 *     class  : com.eiffelyk.weather.weizi.map.MinuteLayout
 *     e-mail : 1012126908@qq.com
 *     time   : 2020/11/08
 *     desc   :
 * </pre>
 */
class MinuteLayout : ConstraintLayout {

    companion object {
        private const val TAG = "MinuteLayout::"
        private const val INVALID_POINTER = -1
        private const val MIN_FLING_DISTANCE = 2000 // 判断 fling 最小距离
        private const val MOVE_DISTANCE_RATIO = 0.5f // 滑动到一半触发消失逻辑

    }

    private val mClickRect = RectF()
    private val mExtendRect = RectF() // 展开时的矩形
    private val mFoldRect = RectF() // 折叠时的矩形
    private var mGapHeight = 0.0f
    private val mScreenWidth = UiUtils.getScreenWidth(context as FragmentActivity)
    private val mScreenHeight = UiUtils.getScreenHeight(context as FragmentActivity)
    private var mControlY = 0.0f
    private var mDestTransitionY // 计算最终平移 Y
            = 0f
    private var mBottomDown // 判断手指是否触摸到底部 view
            = false
    private var mVelocityTracker // 速度跟踪器，用于处理 fling 关闭弹窗
            : VelocityTracker? = null
    private var mLastControlY // 记录 down 时当前的 transitionY
            = 0f
    private var mOffsetY // 每次移动位移值
            = 0f
    private var mExtendEnable // 是否允许展开
            = true
    private var mActivePointerId = 0
    private val mLastPointF // 记录上次手势的位置
            = PointF()
    private val mAnimator by lazy {
        initAnimator()
    }

    constructor(context: Context) : this(context, null)
    constructor(context: Context, attrs: AttributeSet?) : this(context, attrs, -1)
    constructor(context: Context, attrs: AttributeSet?, defStyleAttr: Int) : super(
            context,
            attrs,
            defStyleAttr
    ) {
        View.inflate(context, R.layout.layout_minute_progress, this)
        initRectF()
        setExtendEnable(false)
        LogUtils.i(TAG, "height: $mScreenHeight")
    }

    private fun initAnimator(): ObjectAnimator {
        val valueAnimator = ObjectAnimator.ofFloat(this, "controlY", 0f)
        valueAnimator.duration = 300
        valueAnimator.interpolator = AccelerateInterpolator()
        return valueAnimator
    }

    fun setExtendEnable(extendEnable: Boolean) {
        this.mExtendEnable = extendEnable
        view_minute_bottom.visibility = if (extendEnable) VISIBLE else INVISIBLE
        if (!mExtendEnable) {
            fold()
        } else {
            extend()
        }
    }

    private fun setControlY(controlY: Float) {
        LogUtils.i(TAG, "setControlY: $controlY")
        mControlY = controlY
        if (mControlY < 0) {
            view_bottom_stub.translationY = mControlY
        }
        cl_bottom.translationY = mControlY
    }

    private fun getControlY(): Float {
        return mControlY
    }

    override fun onAttachedToWindow() {
        super.onAttachedToWindow()
        mVelocityTracker = VelocityTracker.obtain()
    }

    override fun onDetachedFromWindow() {
        super.onDetachedFromWindow()
        mVelocityTracker?.clear()
        mVelocityTracker?.recycle()
    }

    private fun getFriction(moveY: Float): Float {
        val distance = -moveY
        val percent = min(distance / mScreenHeight, 1f)
        return -(percent * percent * percent / 3 - percent * percent + percent) * mScreenHeight / 3
    }

    private fun getFrictionDown(moveY: Float): Float {
        val distance = -moveY
        val percent = min(distance / mScreenHeight, 1f)
        return -(percent * percent * percent / 3 - percent * percent + percent) * mScreenHeight * 3 / 5
    }

    private fun getFoldFrictionUp(moveY: Float): Float {
        val distance = -moveY
        val percent = min(distance / mScreenHeight, 1f)
        return -(percent * percent * percent / 3 - percent * percent + percent) * mScreenHeight
    }

    private fun initRectF() {
        val topHeight = resources.getDimensionPixelOffset(R.dimen.minute_top_view_height)
        val progressHeight = resources.getDimensionPixelOffset(R.dimen.minute_progress_height)
        val bottomMargin = resources.getDimensionPixelOffset(R.dimen.minute_progress_margin_bottom)
        val bottomView = resources.getDimensionPixelOffset(R.dimen.minute_bottom_view_height)
        val expandHeight =
                topHeight + progressHeight + bottomMargin * 2 + bottomView
        val foldHeight =
                topHeight + progressHeight + bottomMargin
        mExtendRect.set(
                0f,
                mScreenHeight - expandHeight.toFloat(),
                mScreenWidth.toFloat(),
                mScreenHeight.toFloat()
        )
        mFoldRect.set(
                0f,
                mScreenHeight - foldHeight.toFloat(),
                mScreenWidth.toFloat(),
                mScreenHeight.toFloat()
        )
        mGapHeight = mExtendRect.height() - mFoldRect.height()
    }

    private fun fold() {
        if (!mAnimator.isRunning) {
            LogUtils.i(TAG, "fold: ")
            val duration = abs((mControlY - mGapHeight)) * 1.0f / mExtendRect.height() * 300
            mAnimator.duration = duration.toLong()
            mAnimator.setFloatValues(mControlY, mGapHeight)
            mAnimator.start()
            mClickRect.set(mFoldRect)
        }
    }

    private fun extend() {
        if (!mAnimator.isRunning && mExtendEnable) {
            LogUtils.i(TAG, "extend: ")
            val duration = abs(mControlY) * 1.0f / mExtendRect.height() * 300
            mAnimator.setFloatValues(mControlY, 0f)
            mAnimator.duration = duration.toLong()
            mAnimator.start()
            mClickRect.set(mExtendRect)
        }
    }

    private fun animTo(value: Float) {
        if (!mAnimator.isRunning) {
            LogUtils.i(TAG, "animTo: $value")
            val duration = abs((mControlY - value)) * 1.0f / mClickRect.height() * 300
            mAnimator.duration = duration.toLong()
            mAnimator.setFloatValues(mControlY, value)
            mAnimator.start()
        }
    }

    override fun onTouchEvent(event: MotionEvent): Boolean {
        val actionIndex = event.actionIndex
        var deal = super.onTouchEvent(event)
        if (event.actionMasked == MotionEvent.ACTION_DOWN) {
            mVelocityTracker?.clear()
            mBottomDown = mClickRect.contains(event.x, event.y)
            mOffsetY = 0f
            if (mBottomDown) {
                setControlY(mControlY)
                mLastControlY = mControlY
                mActivePointerId = 0 // 第一根手指按下时，pointerId 和 PointerIndex 都为0
                mLastPointF.set(event.x, event.y)
                deal = true
            }
        } else if (event.actionMasked == MotionEvent.ACTION_POINTER_DOWN) {
            // 新落下的手指，将落下的手指作为活动手指，保存下手指的坐标
            mActivePointerId = event.getPointerId(actionIndex)
            mLastPointF.set(event.getX(actionIndex), event.getY(actionIndex))
        } else if (event.actionMasked == MotionEvent.ACTION_MOVE) {
            if (mActivePointerId == INVALID_POINTER) {
                return true
            }
            if (mBottomDown) {
                val pointerIndex = event.findPointerIndex(mActivePointerId)
                if (pointerIndex == INVALID_POINTER) {
                    return true
                }
                mVelocityTracker?.addMovement(event)
                val v: Float = event.getY(pointerIndex) - mLastPointF.y
                mOffsetY += v
                mDestTransitionY = mLastControlY + mOffsetY

                // 展开时，上拉的阻尼效果
                if (mDestTransitionY < 0) {
                    mDestTransitionY = getFriction(mDestTransitionY)
                }
                mDestTransitionY = min(mDestTransitionY, mExtendRect.height())

                if (!mExtendEnable && mDestTransitionY < mGapHeight) {
                    mDestTransitionY -= getFoldFrictionUp(mDestTransitionY - mGapHeight)
                }

                // 折叠时，下拉的阻尼效果
                if (mDestTransitionY >= mGapHeight) {
                    mDestTransitionY += getFrictionDown(mGapHeight - mDestTransitionY)
                }
                setControlY(mDestTransitionY)
                mLastPointF.set(event.getX(pointerIndex), event.getY(pointerIndex))
            }
        } else if (event.actionMasked == MotionEvent.ACTION_POINTER_UP) {
            //如果当前抬起的手指为活动手指，那么活动手指就传给留下的手指中pointerIndex最前面的一个
            if (mActivePointerId == event.getPointerId(actionIndex)) {
                val newPointerIndex = if (actionIndex == 0) 1 else 0
                mActivePointerId = event.getPointerId(newPointerIndex)
                mLastPointF.set(event.getX(newPointerIndex), event.getY(newPointerIndex))
            }
        } else if (event.actionMasked == MotionEvent.ACTION_UP || event.actionMasked == MotionEvent.ACTION_CANCEL) {
            mActivePointerId =
                    INVALID_POINTER
            if (mBottomDown) {
                mVelocityTracker?.computeCurrentVelocity(1000)
                val velocityY: Float = mVelocityTracker!!.yVelocity
                if (velocityY >= MIN_FLING_DISTANCE) {
                    fold()
                } else {
                    if (mDestTransitionY <= 1f) {
                        if (!mExtendEnable) {
                            fold()
                        } else {
                            extend()
                        }
                        return true
                    }
                    if (mDestTransitionY <= (mGapHeight) * MOVE_DISTANCE_RATIO) {
                        if (!mExtendEnable) {
                            fold()
                        } else {
                            extend()
                        }
                    } else {
                        fold()
                    }
                }
            } else {
                if (!mClickRect.contains(event.x, event.y)) {
                    fold()
                }
            }
            mVelocityTracker!!.clear()
        }
        return deal
    }

}
