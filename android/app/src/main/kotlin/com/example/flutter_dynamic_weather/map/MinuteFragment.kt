package com.eiffelyk.weather.weizi.map

import android.os.*
import android.view.View
import android.widget.Toast
import androidx.appcompat.app.AlertDialog
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.viewModelScope
import com.amap.api.location.AMapLocation
import com.amap.api.location.AMapLocationClient
import com.amap.api.location.AMapLocationClientOption
import com.amap.api.location.AMapLocationListener
import com.amap.api.maps.AMap
import com.amap.api.maps.CameraUpdateFactory
import com.amap.api.maps.LocationSource
import com.amap.api.maps.LocationSource.OnLocationChangedListener
import com.amap.api.maps.model.*
import com.amap.api.services.core.LatLonPoint
import com.amap.api.services.geocoder.GeocodeResult
import com.amap.api.services.geocoder.GeocodeSearch
import com.amap.api.services.geocoder.RegeocodeQuery
import com.amap.api.services.geocoder.RegeocodeResult
import com.example.flutter_dynamic_weather.R
import com.example.flutter_dynamic_weather.base.BaseFragment
import com.example.flutter_dynamic_weather.base.LogUtils
import com.example.flutter_dynamic_weather.map.AmapLocationMarkerView
import kotlinx.android.synthetic.main.fragment_minute.*
import kotlinx.android.synthetic.main.layout_minute_progress.*
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

/**
 * <pre>
 *     author : xiaweizi
 *     class  : com.eiffelyk.weather.weizi.map.MinuteFragment
 *     e-mail : 1012126908@qq.com
 *     time   : 2020/11/08
 *     desc   :
 * </pre>
 */
class MinuteFragment : BaseFragment(), AMap.OnMapClickListener, AMap.OnMapLoadedListener,
        AMap.OnCameraChangeListener, AMapLocationListener, GeocodeSearch.OnGeocodeSearchListener {

    companion object {
        private const val TAG = "Minute-Fragment::"
        private const val MSG_UPDATE = 1
        private const val PER_VALUE = 1f / 50
        private const val GAP_TIME = (1f / 50 * 5000).toLong()
    }

    private var mAMap: AMap? = null
    private var mLocationClient: AMapLocationClient? = null
    private var mLocationChangedListener: OnLocationChangedListener? = null
    private var mSingleMarker: Marker? = null
    private var mSingleGroundOverlay: GroundOverlay? = null
    private var mGeocodeSearch: GeocodeSearch? = null
    private val mMinuteViewModel by lazy {
        ViewModelProvider(this).get(MinuteViewModel::class.java)
    }
    private var mLoadingDialog: AlertDialog? = null
    private var mRainData: List<RainData>? = null
    private var mRatio = 0.0f
    private var mIndex = -1
    private var mIsLoading = false

    private val mHandler = object : Handler(Looper.getMainLooper()) {
        override fun handleMessage(msg: Message) {
            if (msg.what == MSG_UPDATE) {
                if (!mRainData.isNullOrEmpty()) {

                    refreshRatio()
                    view_progress.setRatio(mRatio)
                    mRatio += PER_VALUE
                    if (mRatio >= 1.0f) {
                        LogUtils.i(TAG, "循环结束，重新开始")
                        mRatio = 0.0f
                        sendEmptyMessageDelayed(MSG_UPDATE, 500)
                    } else {
                        sendEmptyMessageDelayed(MSG_UPDATE, GAP_TIME)
                    }
                }
            }
        }
    }

    override fun getLayoutId() = R.layout.fragment_minute

    override fun initView() {
        super.initView()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val decorView: View? = activity?.window?.getDecorView()
            var vis = decorView?.systemUiVisibility
            vis = vis!! or View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR
            decorView?.systemUiVisibility = vis
        }
        iv_minute_back.setOnClickListener {
            finish()
        }
        iv_zoom_in.setOnClickListener {
            mAMap?.animateCamera(CameraUpdateFactory.zoomIn())
        }
        iv_zoom_out.setOnClickListener {
            mAMap?.animateCamera(CameraUpdateFactory.zoomOut())
        }
        iv_minute_locate.setOnClickListener {
            location(true)
        }
        iv_minute_refresh.setOnClickListener {
            fetchData(true)
        }
        initProgress()
    }

    override fun initData() {
        super.initData()
        fetchData()
    }

    private fun fetchData(showToast: Boolean = false) {
        LogUtils.i(TAG, "开始获取雷达图数据")
        if (!mIsLoading) {
            mIsLoading = true
            if (showToast) {
                Toast.makeText(activity!!, "正在刷新中", Toast.LENGTH_SHORT).show()
            }
            mMinuteViewModel.getForecastImages(activity!!.applicationContext) {
                mMinuteViewModel.viewModelScope.launch(Dispatchers.Main) {
                    mIsLoading = false
                    if (showToast) {
                        Toast.makeText(activity!!, "刷新完成", Toast.LENGTH_SHORT).show()
                    }
                    if (!it.isNullOrEmpty()) {
                        minute_layout.visibility = View.VISIBLE
                        mRainData = it
                        initProgress()
                        start()
                    }
                }
            }
        }
    }

    private fun fetchWeatherData(lat: String, long: String) {
        LogUtils.i(TAG, "开始获取天气数据 lat: $lat, long: $long")
        mMinuteViewModel.getAllData(lat, long) {
            LogUtils.i(TAG, "天气数据获取成功")
        }
    }

    private fun initProgress() {
        view_progress.setProgressCallback(object : MinuteProgressView.OnProgressCallback {
            override fun onDown(ratio: Float): Boolean {
                mRatio = ratio
                val isPlaying = mHandler.hasMessages(MSG_UPDATE)
                stop()
                refreshRatio()
                return isPlaying
            }

            override fun onMove(ratio: Float) {
                mRatio = ratio
                refreshRatio()
            }

            override fun onUp(isPlaying: Boolean) {
                if (isPlaying) {
                    start()
                }
            }

        })
        iv_minute_action.setOnClickListener {
            if (mHandler.hasMessages(MSG_UPDATE)) {
                stop()
            } else {
                start()
            }
        }
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        map_view.onCreate(savedInstanceState)
        initAMap()
    }

    private fun initAMap() {
        mAMap = map_view.map
        mAMap?.setLocationSource(object : LocationSource {
            override fun activate(locationChangedListener: OnLocationChangedListener?) {
                LogUtils.i(TAG, "activate: ")
                mLocationChangedListener = locationChangedListener
            }

            override fun deactivate() {
                LogUtils.i(TAG, "deactivate: ")
            }
        })
        mAMap?.isMyLocationEnabled = true
        mAMap?.setOnMapClickListener(this)
        mAMap?.setOnMapLoadedListener(this)
        mAMap?.setOnCameraChangeListener(this)
        mAMap?.animateCamera(CameraUpdateFactory.zoomTo(9f))
        val uiSettings = mAMap?.uiSettings
        uiSettings?.isZoomControlsEnabled = false
        mGeocodeSearch = GeocodeSearch(activity!!.application)
        mGeocodeSearch?.setOnGeocodeSearchListener(this)
        location()
    }

    private fun refreshRatio() {
        val size = mRainData!!.size
        val index: Int = ((size - 1) * mRatio).toInt()
        refreshCloud(index)
    }

    private fun refreshCloud(index: Int) {
        val rainData: RainData?
        if (mRainData != null && mIndex != index && index >= 0 && index < mRainData!!.size) {
            mIndex = index
            rainData = mRainData!![mIndex]
            if (rainData.srcBitmap != null) {
                val bounds =
                        LatLngBounds.builder().include(LatLng(rainData.leftLat, rainData.leftLong))
                                .include(LatLng(rainData.rightLat, rainData.rightLong)).build()
                if (null == mSingleGroundOverlay) {
                    val groundOverlayOptions = GroundOverlayOptions().apply {
                        anchor(0.5f, 0.5f)
                        transparency(0.1f)
                        image(BitmapDescriptorFactory.fromBitmap(rainData.srcBitmap))
                        positionFromBounds(bounds)
                    }
                    mSingleGroundOverlay = mAMap?.addGroundOverlay(groundOverlayOptions)
                } else {
                    mSingleGroundOverlay?.apply {
                        setImage(BitmapDescriptorFactory.fromBitmap(rainData.srcBitmap))
                        setPositionFromBounds(bounds)
                        isVisible = true
                    }
                }
            } else {
                LogUtils.i(TAG, "获取图片失败")
            }
        }
    }

    private fun start() {
        LogUtils.i(TAG, "开始循环刷新")
        if (!mHandler.hasMessages(MSG_UPDATE)) {
            mHandler.sendEmptyMessage(MSG_UPDATE)
            iv_minute_action.setImageResource(R.mipmap.ic_rain_area_pause)
        }
    }

    private fun stop() {
        if (mHandler.hasMessages(MSG_UPDATE)) {
            mHandler.removeMessages(MSG_UPDATE)
            if (iv_minute_action != null) {
                iv_minute_action.setImageResource(R.mipmap.ic_rain_area_play)
            }
        }
    }

    private fun location(showLoading: Boolean = false) {
        LogUtils.i(TAG, "开始定位")
        if (showLoading) {
//            mLoadingDialog = AlertDialogFactory.createLocationLoadingDialog(activity!!)
        }
        mSingleMarker?.destroy()
        if (mLocationClient == null) {
            initCurrentLocationStyle()
            val locationClientOption = AMapLocationClientOption()
            locationClientOption.isOnceLocation = true
            locationClientOption.locationMode =
                    AMapLocationClientOption.AMapLocationMode.Hight_Accuracy
            mLocationClient = AMapLocationClient(activity!!.application)
            mLocationClient?.setLocationListener(this)
            mLocationClient?.setLocationOption(locationClientOption)
            AMapLocationClientOption.setLocationProtocol(AMapLocationClientOption.AMapLocationProtocol.HTTPS)
        }
        mLocationClient?.startLocation()
    }

    private fun initCurrentLocationStyle() {
        val locationStyle = MyLocationStyle()
        val markerView = AmapLocationMarkerView(activity!!)
        locationStyle.myLocationIcon(BitmapDescriptorFactory.fromView(markerView))
        mAMap?.myLocationStyle = locationStyle
    }

    private fun refreshTitle(content: String) {
        tv_minute_title.text = content
    }

    override fun onResume() {
        super.onResume()
        map_view?.onResume()
    }

    override fun onPause() {
        super.onPause()
        map_view?.onPause()
    }

    override fun onDestroy() {
        super.onDestroy()
        map_view?.onDestroy()
        mGeocodeSearch?.setOnGeocodeSearchListener(null)
        stop()
    }

    override fun onMapClick(latLng: LatLng?) {
        LogUtils.i(TAG, "onMapClick: ")
        mSingleMarker?.destroy()
        mAMap?.animateCamera(CameraUpdateFactory.changeLatLng(latLng))
        val markerOptions = MarkerOptions()
        markerOptions.visible(true)
        markerOptions.icon(BitmapDescriptorFactory.fromResource(R.mipmap.icon_location))
        markerOptions.position(latLng)
        markerOptions.anchor(0.5f, 0.7f)
        mSingleMarker = mAMap?.addMarker(markerOptions)
        if (latLng != null) {
            val latLonPoint = LatLonPoint(latLng.latitude, latLng.longitude)
            val query = RegeocodeQuery(latLonPoint, 1000f, GeocodeSearch.AMAP)
            mGeocodeSearch?.getFromLocationAsyn(query)
        }
        fetchWeatherData(latLng?.latitude.toString(), latLng?.longitude.toString())
    }

    override fun onMapLoaded() {
        LogUtils.i(TAG, "onMapLoaded: ")
    }

    override fun onCameraChange(cameraPosition: CameraPosition?) {
        LogUtils.i(TAG, "onCameraChange: ")
    }

    override fun onCameraChangeFinish(cameraPosition: CameraPosition?) {
        LogUtils.i(TAG, "onCameraChangeFinish: ")
    }

    override fun onLocationChanged(aMapLocation: AMapLocation?) {
        if (aMapLocation != null) {
            LogUtils.i(TAG, "onLocationChanged: ${aMapLocation.toStr()}")
            if (aMapLocation.errorCode == AMapLocation.LOCATION_SUCCESS) {
                mAMap?.animateCamera(
                        CameraUpdateFactory.changeLatLng(
                                LatLng(
                                        aMapLocation.latitude,
                                        aMapLocation.longitude
                                )
                        )
                )
                refreshTitle(aMapLocation.poiName)
                mLocationChangedListener?.onLocationChanged(aMapLocation)
                fetchWeatherData(aMapLocation.latitude.toString(), aMapLocation.longitude.toString())
            } else {
                Toast.makeText(activity!!, "定位失败", Toast.LENGTH_SHORT).show()
            }
        }
        mLoadingDialog?.dismiss()
    }

    override fun onRegeocodeSearched(regeocodeResult: RegeocodeResult?, i: Int) {
        val point = regeocodeResult?.regeocodeQuery?.point
        val regeocodeAddress = regeocodeResult!!.regeocodeAddress
        refreshTitle(regeocodeAddress.formatAddress)
    }

    override fun onGeocodeSearched(p0: GeocodeResult?, p1: Int) {

    }

}