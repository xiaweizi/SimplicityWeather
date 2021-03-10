package com.example.flutter_dynamic_weather

import android.app.Service
import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.graphics.*
import android.os.*
import android.util.Log
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors

class WeatherAnimWidgetService : Service() {

    private val mMainHandler = Handler(Looper.myLooper()!!)
    private var mBitmapHandler: Handler? = null
    private var mBitmapLooper: Looper? = null
    private val mSizeMap = hashMapOf<Int, Point>()
    private val mPaint = Paint(Paint.ANTI_ALIAS_FLAG)
    private val mRainParam = mutableListOf<RainParam>()
    private val mClipPath = Path();

    companion object {
        private const val TAG = "WeatherService::"
        fun startService(context: Context) {
            context.startService(Intent(context, WeatherAnimWidgetService::class.java))
        }
    }

    override fun onBind(intent: Intent): IBinder? {
        return null
    }

    override fun onCreate() {
        super.onCreate()
        Log.d(TAG, "onCreate: ")
        val thread = HandlerThread("widgetService")
        thread.start()
        mBitmapLooper = thread.looper
        mBitmapHandler = BitmapHandler(mBitmapLooper!!)
        mBitmapHandler?.sendEmptyMessage(1)
    }

    private fun updateWidget() {
        val manager = AppWidgetManager.getInstance(this)
        val ids = manager.getAppWidgetIds(ComponentName(this, WeatherAnimWidget::class.java))
        ids.forEach {
            val point = mSizeMap[it]
            if (point != null) {
                prepareRainParam(point)
                val bitmap = createBitmap(point)
                mMainHandler.post {
                    WeatherAnimWidget.updateAppWidget(this, manager, it, bitmap)
                }
            }
        }
    }

    internal inner class BitmapHandler(looper: Looper) : Handler(looper) {
        override fun handleMessage(msg: Message) {
            super.handleMessage(msg)
            Log.d(TAG, "handleMessage: ")
            if (!WeatherResFactory.instance.isPrepare) {
                WeatherResFactory.instance.prepareRes(context = this@WeatherAnimWidgetService)
            }
            while (true) {
                preparePoint()
                updateWidget()
            }
        }
    }

    private fun preparePoint() {
        // 初始化宽高
        mSizeMap.clear()
        val manager = AppWidgetManager.getInstance(this)
        val ids = manager.getAppWidgetIds(ComponentName(this, WeatherAnimWidget::class.java))
        ids.forEach {
            val maxWidth = manager.getAppWidgetOptions(it).getInt(AppWidgetManager.OPTION_APPWIDGET_MAX_WIDTH)
            val minWidth = manager.getAppWidgetOptions(it).getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_WIDTH)
            val maxHeight = manager.getAppWidgetOptions(it).getInt(AppWidgetManager.OPTION_APPWIDGET_MAX_HEIGHT)
            val minHeight = manager.getAppWidgetOptions(it).getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_HEIGHT)
            Log.d(TAG, "preparePoint: id: $it, maxWidth: $maxWidth, minWidth: $minWidth, maxHeight: $maxHeight, minHeight: $minHeight")
            mSizeMap[it] = Point(maxWidth, maxHeight)
        }
    }

    private fun prepareRainParam(point: Point) {
        if (mRainParam.isNullOrEmpty()) {
            for (i in 0..150) {
                mRainParam.add(RainParam(point = point))
            }

        }
    }

    private fun createBitmap(point: Point): Bitmap {
        val bitmap = Bitmap.createBitmap(point.x, point.y, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(bitmap)
        canvas.save()
        mClipPath.reset()
        mClipPath.addRoundRect(0f, 0f, point.x.toFloat(), point.y.toFloat(), 30f, 30f, Path.Direction.CCW)
        canvas.clipPath(mClipPath)
        drawBackground(canvas, point)
        drawRain(canvas)
        canvas.restore()
        return bitmap
    }

    private fun drawRain(canvas: Canvas) {
        mRainParam.forEach {
            canvas.save()
            canvas.scale(it.scale, it.scale)
            mPaint.alpha = (it.alpha * 255).toInt()
            canvas.drawBitmap(it.bitmap, it.x, it.y, mPaint)
            canvas.restore()
            it.move()
        }
    }

    private fun drawBackground(canvas: Canvas, point: Point) {
        mPaint.color = resources.getColor(R.color.light_blue_900)
        mPaint.alpha = 255
        canvas.drawRect(0f, 0f, point.x.toFloat(), point.y.toFloat(), mPaint)
    }

    override fun onDestroy() {
        super.onDestroy()
        mBitmapLooper?.quit()
    }
}