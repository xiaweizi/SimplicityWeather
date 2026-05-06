import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dynamic_weather/app/res/dimen_constant.dart';
import 'package:flutter_dynamic_weather/app/res/widget_state.dart';
import 'package:flutter_dynamic_weather/app/utils/location_util.dart';
import 'package:flutter_dynamic_weather/app/utils/print_utils.dart';
import 'package:flutter_dynamic_weather/app/utils/shared_preference_util.dart';
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

  const CityView({super.key, required this.cityModel});

  @override
  State<CityView> createState() => _CityViewState();
}

class _CityViewState extends State<CityView>
    with AutomaticKeepAliveClientMixin {
  WeatherModelEntity? _modelEntity;
  ScrollController? _controller;
  StreamSubscription? _subscription;

  AppWidgetState _state = AppWidgetState.loading;

  Future<void> refresh() async {
    weatherPrint("开始获取当前城市的数据 ${widget.cityModel.displayedName}");
    if (!mounted) return;
    context.read<WeatherBloc>().add(FetchWeatherDataEvent(widget.cityModel));
  }

  Widget _buildCityContent() {
    weatherPrint('build city content, state: $_state');
    if (_state == AppWidgetState.success) {
      return RefreshIndicator(
        onRefresh: () async {
          refresh();
        },
        child: SingleChildScrollView(
          controller: _controller,
          physics: const BouncingScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: DimenConstant.cardMarginStartEnd),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RealtimeView(
                    entity: _modelEntity!, cityModel: widget.cityModel),
                AqiChartView(entity: _modelEntity!),
                const SizedBox(
                    height: DimenConstant.dayForecastMarginBottom),
                DayForecastView(
                  resultDaily: _modelEntity?.result?.daily,
                  modelEntity: _modelEntity,
                ),
                const SizedBox(
                    height: DimenConstant.dayForecastMarginBottom),
                const SizedBox(
                    height: DimenConstant.dayForecastMarginBottom),
                const SizedBox(height: 10),
                HourForecastView(
                  resultHourly: _modelEntity?.result?.hourly,
                ),
                const SizedBox(height: 30),
                RealTimeDetailView(entity: _modelEntity!),
                const SizedBox(height: 30),
                LifeIndexView(
                  modelResultDailyLifeIndex:
                      _modelEntity?.result?.daily?.lifeIndex,
                  skycon: _modelEntity?.result?.realtime?.skycon,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/caiyun.png",
                      width: 40,
                      height: 40,
                      color: Colors.white54,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "数据来自彩云科技",
                      style: TextStyle(color: Colors.white54),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      );
    } else if (_state == AppWidgetState.error) {
      return const StateView(weatherState: ViewState.error);
    } else {
      return const StateView(weatherState: ViewState.loading);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocListener<WeatherBloc, WeatherState>(
      listener: (_, state) {
        weatherPrint("城市页面收到事件 state: ${state.runtimeType}");
        if (state is WeatherSuccess) {
          if (state.cityModel.cityFlag == widget.cityModel.cityFlag) {
            setState(() {
              _state = AppWidgetState.success;
              _modelEntity = state.entity;
            });
          }
        } else if (state is WeatherLoading) {
          if (state.cityModel != null &&
              state.cityModel!.cityFlag == widget.cityModel.cityFlag &&
              _modelEntity == null) {
            setState(() {
              _state = AppWidgetState.loading;
            });
          }
        } else if (state is WeatherFailed) {
          if (state.cityModel.cityFlag == widget.cityModel.cityFlag &&
              _modelEntity == null) {
            setState(() {
              _state = AppWidgetState.error;
            });
          }
        }
      },
      child: _buildCityContent(),
    );
  }

  @override
  void initState() {
    super.initState();
    weatherPrint('initState-${widget.cityModel.cityFlag}');
    getDataFromCache();
    refresh();
    final initValue = offsetNotifier.value;
    weatherPrint("init-value: $initValue");
    _controller = ScrollController(initialScrollOffset: initValue);
    _controller!.addListener(() {
      offsetNotifier.value = _controller!.offset;
    });
    _subscription = eventBus.on<ChangeMainAppBarIndexEvent>().listen((event) {
      if (event.cityFlag == widget.cityModel.cityFlag) {
        _controller?.jumpTo(offsetNotifier.value);
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  Future<void> getDataFromCache() async {
    weatherPrint("city view: getDataFromCache");
    final value = await SPUtil.getAllWeatherModels();
    final key = LocationUtil.convertCityFlag(
        widget.cityModel.cityFlag, widget.cityModel.isLocated ?? false);
    weatherPrint("city view: $key");
    if (value != null && value.isNotEmpty) {
      final modelStr = value[key];
      if (modelStr == null || modelStr.isEmpty) return;
      if (!mounted) return;
      setState(() {
        _state = AppWidgetState.success;
        _modelEntity = WeatherModelEntity().fromJson(json.decode(modelStr));
      });
      weatherPrint("城市页面从缓存获取数据成功 $_modelEntity");
    }
  }

  @override
  bool get wantKeepAlive => true;
}
