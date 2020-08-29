import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dynamic_weather/app/res/analytics_constant.dart';
import 'package:flutter_dynamic_weather/app/router.dart';
import 'package:flutter_dynamic_weather/app/utils/print_utils.dart';
import 'package:flutter_dynamic_weather/app/utils/shared_preference_util.dart';
import 'package:flutter_dynamic_weather/app/utils/toast.dart';
import 'package:flutter_dynamic_weather/bloc/city/city_bloc.dart';
import 'package:flutter_dynamic_weather/model/city_model_entity.dart';
import 'package:flutter_dynamic_weather/views/bg/weather_main_bg.dart';
import 'package:flutter_dynamic_weather/views/common/loading_view.dart';
import 'package:flutter_dynamic_weather/views/pages/home/main_app_bar.dart';
import 'package:flutter_dynamic_weather/views/pages/home/main_message.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:umeng_analytics_plugin/umeng_analytics_plugin.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();

  HomePage({Key key}) : super(key:key);
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin{
  var locationState;

  Future<void> init() async {
    await UmengAnalyticsPlugin.init(
      androidKey: '5f43cf00b4b08b653e98cc1a',
      iosKey: '5f43cf6db4b08b653e98cc1f',
      channel: "github",
    );
    UmengAnalyticsPlugin.event(AnalyticsConstant.initMainPage, label: Platform.operatingSystem);
  }

  @override
  void initState() {
    weatherPrint("umeng init event ${Platform.operatingSystem}");
    init();
    super.initState();
  }

  Widget _buildHomeContent(List<CityModel> cityModels) {
    weatherPrint("build home content: ${cityModels?.length}");
    return Column(
      children: [
        MainAppBar(cityModels: cityModels),
        Expanded(
          child: MainMessage(),
        )
      ],
    );
  }

  Future<void> requestPermission() async {
    await Future.delayed(Duration(seconds: 2));
    var permissionStatus = await LocationPermissions().checkPermissionStatus();
    weatherPrint('当前权限状态：$permissionStatus');
    if (permissionStatus != PermissionStatus.granted) {
      var permissionResult = await LocationPermissions().requestPermissions(permissionLevel: LocationPermissionLevel.locationWhenInUse);
      if (permissionResult == PermissionStatus.granted) {
        await Future.delayed(Duration(seconds: 1));
        setState(() {
          locationState = LocatePermissionState.success;
        });
      } else {
        var models = await SPUtil.getCityModels();
        if (models == null || models.isEmpty) {
          Navigator.of(context).pushNamed(Router.search);
        }
        ToastUtils.show("请打开定位权限", context, duration: 2);
      }
    } else {
      setState(() {
        locationState = LocatePermissionState.success;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      body: Stack(
        children: [
          WeatherMainBg(),
          Container(
              padding: EdgeInsets.only(
                  top: MediaQueryData.fromWindow(WidgetsBinding.instance.window)
                      .padding
                      .top),
              child: BlocBuilder<CityBloc, CityState>(
                builder: (_, s) {
                  weatherPrint(
                      'homePage， state: ${s.runtimeType}, locationState: $locationState');
                  if (s is CitySuccess) {
                    return _buildHomeContent(s.cityModels);
                  } else if (s is CityInit) {
                    if (locationState == null) {
                      locationState = LocatePermissionState.loading;
                      requestPermission();
                    } else if (locationState == LocatePermissionState.success) {
                      BlocProvider.of<CityBloc>(context).add(RequestLocationEvent());
                    }
                    return Container(
                      alignment: Alignment.center,
                      child: Container(),
                    );
                  } else if (s is LocationSuccessState) {
                    return Container(
                      alignment: Alignment.center,
                      child: Container(),
                    );
                  }
                  return StateView(weatherState: ViewState.loading);
                },
              )),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

enum LocatePermissionState {
  success,
  loading,
  failed,
}
