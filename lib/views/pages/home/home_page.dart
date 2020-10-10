import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dynamic_weather/app/res/analytics_constant.dart';
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

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();

  HomePage({Key key}) : super(key:key);
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin{
  @override
  void initState() {
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
                  if (s is CitySuccess) {
                    return _buildHomeContent(s.cityModels);
                  } else if (s is CityInit) {
                    BlocProvider.of<CityBloc>(context).add(RequestLocationEvent());
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
