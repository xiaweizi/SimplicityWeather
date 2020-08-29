import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dynamic_weather/app/utils/print_utils.dart';
import 'package:flutter_dynamic_weather/bloc/city/city_bloc.dart';
import 'package:flutter_dynamic_weather/event/change_index_envent.dart';
import 'package:flutter_dynamic_weather/model/city_model_entity.dart';
import 'package:flutter_dynamic_weather/model/weather_model_entity.dart';
import 'package:flutter_dynamic_weather/views/app/flutter_app.dart';
import 'package:flutter_dynamic_weather/views/common/loading_view.dart';
import 'package:flutter_dynamic_weather/views/pages/home/city_view.dart';

class MainMessage extends StatefulWidget {
  @override
  _MainMessageState createState() => _MainMessageState();
}

class _MainMessageState extends State<MainMessage> {
  List<CityModel> _cityModels;
  PageController _controller = PageController();
  StreamSubscription _subscription;

  Widget _buildMainWidget() {
    weatherPrint('main-build main widget');
    if (_cityModels == null) {
      return StateView(weatherState: ViewState.loading);
    } else if (_cityModels.isEmpty) {
      return StateView(weatherState: ViewState.empty);
    } else {
      weatherPrint("创建城市列表页面");
      weatherPrint('main-success, cityModel: $_cityModels');
      return PageView.builder(
        controller: _controller,
        onPageChanged: (index) {
          weatherPrint('current index: $index');
          eventBus.fire(ChangeMainAppBarIndexEvent(index, _cityModels[index].cityFlag));
        },
        itemBuilder: (context, index) {
          return CityView(
            cityModel: _cityModels[index],
          );
        },
        itemCount: _cityModels.length,
      );
    }
  }

  @override
  void initState() {
    _subscription = eventBus.on<ChangeCityEvent>().listen((event) {
      if (_cityModels != null) {
        _cityModels.forEach((element) {
          if (element.cityFlag == event.cityFlag) {
            var index = _cityModels.indexOf(element);
            if (index >= 0 && index < _cityModels.length) {
              _controller.jumpToPage(index);
            }
          }
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var state = BlocProvider.of<CityBloc>(context).state;
    weatherPrint('build || main-state: ${state.runtimeType}');
    if (state is CitySuccess) {
      _cityModels = state.cityModels;
    }
    return BlocListener<CityBloc, CityState>(
      listener: (_, state) {
        weatherPrint('BlocListener || main-state: ${state.runtimeType}');
        if (state is CitySuccess) {
          setState(() {
            _cityModels = state.cityModels;
          });
        }
      },
      child: _buildMainWidget(),
    );
  }
}
