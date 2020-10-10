import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dynamic_weather/app/res/dimen_constant.dart';
import 'package:flutter_dynamic_weather/app/res/widget_state.dart';
import 'package:flutter_dynamic_weather/app/utils/location_util.dart';
import 'package:flutter_dynamic_weather/app/utils/print_utils.dart';
import 'package:flutter_dynamic_weather/app/utils/shared_preference_util.dart';
import 'package:flutter_dynamic_weather/bloc/city/city_bloc.dart';
import 'package:flutter_dynamic_weather/bloc/weather/weather_bloc.dart';
import 'package:flutter_dynamic_weather/event/change_index_envent.dart';
import 'package:flutter_dynamic_weather/model/city_model_entity.dart';
import 'package:flutter_dynamic_weather/model/weather_model_entity.dart';
import 'package:flutter_dynamic_weather/views/app/flutter_app.dart';
import 'package:flutter_dynamic_weather/views/common/loading_view.dart';
import 'package:flutter_dynamic_weather/views/pages/home/aqi_chart.dart';
import 'package:flutter_dynamic_weather/views/pages/home/day_forecast.dart';
import 'package:flutter_dynamic_weather/views/pages/home/hour_forecast.dart';
import 'package:flutter_dynamic_weather/views/pages/home/life_index.dart';
import 'package:flutter_dynamic_weather/views/pages/home/real_time.dart';
import 'package:flutter_dynamic_weather/views/pages/home/real_time_detail.dart';


class CityView extends StatefulWidget {
  final CityModel cityModel;

  const CityView({Key key, @required this.cityModel}) : super(key: key);

  @override
  _CityViewState createState() => _CityViewState();
}

class _CityViewState extends State<CityView>
    with AutomaticKeepAliveClientMixin {
  WeatherModelEntity _modelEntity;
  ScrollController _controller;
  StreamSubscription _subscription;

  WidgetState _state = WidgetState.loading;

  Future<void> refresh() async {
    weatherPrint("开始获取当前城市的数据 ${widget.cityModel.displayedName}");
    BlocProvider.of<WeatherBloc>(context)
        .add(FetchWeatherDataEvent(widget.cityModel));
  }

  Widget _buildCityContent() {
    weatherPrint('build city content, state: $_state');
    if (_state == WidgetState.success) {
      weatherPrint("创建单个城市数据");
      return RefreshIndicator(
        onRefresh: () async {
          refresh();
        },
        child: SingleChildScrollView(
          controller: _controller,
          physics: BouncingScrollPhysics(),
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: DimenConstant.cardMarginStartEnd),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RealtimeView(entity: _modelEntity, cityModel: widget.cityModel,),
                AqiChartView(entity: _modelEntity),
                SizedBox(
                  height: DimenConstant.dayForecastMarginBottom,
                ),
                DayForecastView(resultDaily: _modelEntity?.result?.daily, modelEntity: _modelEntity,),
                SizedBox(
                  height: DimenConstant.dayForecastMarginBottom,
                ),
                SizedBox(
                  height: DimenConstant.dayForecastMarginBottom,
                ),
                SizedBox(
                  height: 10,
                ),
                HourForecastView(
                  resultHourly: _modelEntity?.result?.hourly,
                ),
                SizedBox(
                  height: 30,
                ),
                RealTimeDetailView(entity: _modelEntity,),
                SizedBox(
                  height: 30,
                ),
                LifeIndexView(
                  modelResultDailyLifeIndex:
                      _modelEntity?.result?.daily?.lifeIndex,
                  skycon: _modelEntity?.result?.realtime?.skycon,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/caiyun.png", width: 40, height: 40, color: Colors.white54,),
                      SizedBox(width: 10,),
                      Text("数据来自彩云科技", style: TextStyle(color: Colors.white54),),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      );
    } else if (_state == WidgetState.error) {
      return StateView(
        weatherState: ViewState.error,
      );
    } else {
      return StateView(weatherState: ViewState.loading);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WeatherBloc, WeatherState>(
      listener: (_, state) {
        weatherPrint("城市页面收到事件 state: ${state.runtimeType}");
        if (state is WeatherSuccess) {
          weatherPrint(
              'success-current flag: ${widget.cityModel.cityFlag}, target flag: ${state.cityModel.cityFlag}');
          if (state.cityModel.cityFlag == widget.cityModel.cityFlag) {
            setState(() {
              _state = WidgetState.success;
              _modelEntity = state.entity;
            });
          }
        } else if (state is WeatherLoading) {
          weatherPrint(
              'success-current flag: ${widget.cityModel.cityFlag}, target flag: ${state.cityModel}');
          if (state.cityModel != null &&
              state.cityModel.cityFlag == widget.cityModel.cityFlag &&
              _modelEntity == null) {
            setState(() {
              _state = WidgetState.loading;
            });
          }
        } else if (state is WeatherFailed) {
          weatherPrint(
              'fail-current flag: ${widget.cityModel.cityFlag}, target flag: ${state.cityModel.cityFlag}');
          if (state.cityModel.cityFlag == widget.cityModel.cityFlag &&
              _modelEntity == null) {
            setState(() {
              _state = WidgetState.error;
            });
          }
        }
      },
      child: _buildCityContent(),
    );
  }

  @override
  void initState() {
    weatherPrint('initState-${widget.cityModel.cityFlag}');
    getDataFromCache();
    refresh();
    double initValue = 0;
    if (offsetNotifier.value != null) {
      initValue = offsetNotifier.value;
    }
    weatherPrint("init-value: $initValue");
    _controller = ScrollController(initialScrollOffset: initValue);
    _controller.addListener(() {
      offsetNotifier.value = _controller.offset;
    });
    _subscription = eventBus.on<ChangeMainAppBarIndexEvent>().listen((event) {
      if (offsetNotifier.value != null &&
          event.cityFlag == widget.cityModel.cityFlag) {
        _controller.jumpTo(offsetNotifier.value);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  Future<void> getDataFromCache() async {
    weatherPrint("city view: getDataFromCache");
    SPUtil.getAllWeatherModels().then((value) {
      var key = LocationUtil.convertCityFlag(
          widget.cityModel.cityFlag, widget.cityModel.isLocated);
      weatherPrint("city view: $key");
      if (value != null && value.isNotEmpty) {
        var modelStr = value[key];
        if (modelStr == null || modelStr == "") {
          return;
        }
        setState(() {
          _state = WidgetState.success;
          _modelEntity = WeatherModelEntity().fromJson(json.decode(modelStr));
        });
        weatherPrint("城市页面从缓存获取数据成功 $_modelEntity");
      }
    });
  }

  @override
  bool get wantKeepAlive => true;
}
