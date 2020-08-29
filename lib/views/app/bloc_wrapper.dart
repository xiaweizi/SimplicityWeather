import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dynamic_weather/bloc/city/city_bloc.dart';
import 'package:flutter_dynamic_weather/bloc/weather/weather_bloc.dart';
import 'package:flutter_dynamic_weather/net/weather_api.dart';

class BlocWrapper extends StatelessWidget {
  final Widget child;
  final weatherApi = WeatherApi();

  BlocWrapper({@required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CityBloc>(create: (_) => CityBloc(weatherApi)..add(FetchCityDataEvent())),
        BlocProvider<WeatherBloc>(create: (_) => WeatherBloc(weatherApi)),
      ],
      child: child,
    );
  }
}
