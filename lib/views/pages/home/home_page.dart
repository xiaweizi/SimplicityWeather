import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dynamic_weather/app/router.dart';
import 'package:flutter_dynamic_weather/app/utils/ota_utils.dart';
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
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  LocatePermissionState? locationState;

  @override
  void initState() {
    super.initState();
    weatherPrint("init event ${Platform.operatingSystem}");
    OTAUtils.initOTA();
  }

  Widget _buildHomeContent(List<CityModel> cityModels) {
    weatherPrint("build home content: ${cityModels.length}");
    return Column(
      children: [
        MainAppBar(cityModels: cityModels),
        const Expanded(child: MainMessage()),
      ],
    );
  }

  Future<void> requestPermission() async {
    await Future.delayed(const Duration(seconds: 2));
    var status = await Permission.locationWhenInUse.status;
    weatherPrint('当前权限状态：$status');
    if (!status.isGranted) {
      status = await Permission.locationWhenInUse.request();
      if (status.isGranted) {
        await Future.delayed(const Duration(seconds: 1));
        if (!mounted) return;
        setState(() {
          locationState = LocatePermissionState.success;
        });
      } else {
        final models = await SPUtil.getCityModels();
        if (!mounted) return;
        if (models == null || models.isEmpty) {
          Navigator.of(context).pushNamed(WeatherRouter.search);
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
    super.build(context);
    // flutter_screenutil 5.x 的初始化：必须在 MaterialApp 下且使用 ScreenUtilInit。
    // 这里做一次性配置以兼容老代码的 ScreenUtil.xxx 使用。
    ScreenUtil.init(context, designSize: const Size(750, 1334));
    return Scaffold(
      body: Stack(
        children: [
          const WeatherMainBg(),
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: BlocBuilder<CityBloc, CityState>(
              builder: (ctx, s) {
                weatherPrint(
                    'homePage, state: ${s.runtimeType}, locationState: $locationState');
                if (s is CitySuccess) {
                  return _buildHomeContent(s.cityModels);
                } else if (s is CityInit) {
                  if (locationState == null) {
                    locationState = LocatePermissionState.loading;
                    requestPermission();
                  } else if (locationState == LocatePermissionState.success) {
                    ctx.read<CityBloc>().add(const RequestLocationEvent());
                  }
                  return const SizedBox.shrink();
                } else if (s is LocationSuccessState) {
                  return const SizedBox.shrink();
                }
                return const StateView(weatherState: ViewState.loading);
              },
            ),
          ),
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
