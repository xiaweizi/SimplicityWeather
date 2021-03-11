package com.example.flutter_dynamic_weather

import android.app.Service
import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.graphics.*
import android.os.*
import android.util.Log

class WeatherAnimWidgetService : Service() {

    private val mMainHandler = Handler(Looper.myLooper()!!)
    private var mBitmapHandler: Handler? = null
    private var mBitmapLooper: Looper? = null
    private val mSizeMap = hashMapOf<Int, Point>()
    private val mPaint = Paint(Paint.ANTI_ALIAS_FLAG)
    private val mRainParam = mutableListOf<RainParam>()
    private val mThunderParam = mutableListOf<ThunderParam>()
    private val mClipPath = Path()
    private val mColorMatrix = ColorMatrix(floatArrayOf(
            0.19f, 0f, 0f, 0f, 0f,
            0f, 0.2f, 0f, 0f, 0f,
            0f, 0f, 0.22f, 0f, 0f,
            0f, 0f, 0f, 1f, 0f,
    ))
    private val mRainBgColor = intArrayOf(
            Color.parseColor("#565d66"), Color.parseColor("#545b64"),
            Color.parseColor("#515861"), Color.parseColor("#4e555f"),
            Color.parseColor("#4b535c"), Color.parseColor("#49505a"),
            Color.parseColor("#454d57"), Color.parseColor("#424a54"),
            Color.parseColor("#3f4651"), Color.parseColor("#3b434e"))
    private val mRainOffset = floatArrayOf(0f, 1 / 9f, 2 / 9f, 3 / 9f, 4 / 9f, 5 / 9f, 6 / 9f, 7 / 9f, 8 / 9f, 9 / 9f
    )

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
                prepareThunderParam(point)
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

    private fun prepareThunderParam(point: Point) {
        if (mThunderParam.isNullOrEmpty()) {
            for (i in 0..5) {
                mThunderParam.add(ThunderParam(point = point))
            }
        }
    }

    private fun createBitmap(point: Point): Bitmap {
        val lastTime = System.currentTimeMillis()
        val bitmap = Bitmap.createBitmap(point.x, point.y, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(bitmap)
        canvas.save()
        mClipPath.reset()
        mClipPath.addRoundRect(0f, 0f, point.x.toFloat(), point.y.toFloat(), 30f, 30f, Path.Direction.CCW)
        canvas.clipPath(mClipPath)
        drawBackground(canvas, point)
        drawThunder(canvas)
        drawRain(canvas, point)
        drawCloud(canvas)
        canvas.restore()
        Log.d(TAG, "createBitmap: totalTime4: ${System.currentTimeMillis() - lastTime}")
        return bitmap
    }

    private fun drawRain(canvas: Canvas, point: Point) {
        mRainParam.forEach {
            canvas.save()
            canvas.scale(it.scale, it.scale)
            mPaint.alpha = (it.alpha * 255).toInt()
            canvas.drawBitmap(it.bitmap, it.x, it.y, mPaint)
            canvas.restore()
            it.move(point)
        }
    }

    private fun drawThunder(canvas: Canvas) {
        mThunderParam.forEach {
            canvas.save()
            mPaint.alpha = (it.alpha * 255).toInt()
            canvas.drawBitmap(it.bitmap, it.x, it.y, mPaint)
            canvas.restore()
            it.move()
        }
    }

    private fun drawCloud(canvas: Canvas) {
        canvas.save()
        canvas.scale(1.4f, 1.4f)
        mPaint.colorFilter = ColorMatrixColorFilter(mColorMatrix)
        canvas.drawBitmap(WeatherResFactory.instance.cloudBitmap!!, -20f, -40f, mPaint)
        canvas.restore()
        mPaint.colorFilter = null
    }

    private fun drawBackground(canvas: Canvas, point: Point) {
        mPaint.color = Color.parseColor("#565d66")
        mPaint.alpha = 255
        canvas.drawRect(0f, 0f, point.x.toFloat(), point.y.toFloat(), mPaint)
    }

    override fun onDestroy() {
        super.onDestroy()
        mBitmapLooper?.quit()
        WeatherResFactory.instance.release()
    }
}