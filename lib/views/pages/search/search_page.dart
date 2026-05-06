import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dynamic_weather/app/res/weather_type.dart';
import 'package:flutter_dynamic_weather/app/res/widget_state.dart';
import 'package:flutter_dynamic_weather/app/utils/location_util.dart';
import 'package:flutter_dynamic_weather/app/utils/print_utils.dart';
import 'package:flutter_dynamic_weather/app/utils/shared_preference_util.dart';
import 'package:flutter_dynamic_weather/app/utils/toast.dart';
import 'package:flutter_dynamic_weather/bloc/city/city_bloc.dart';
import 'package:flutter_dynamic_weather/event/change_index_envent.dart';
import 'package:flutter_dynamic_weather/model/city_data.dart';
import 'package:flutter_dynamic_weather/model/city_model_entity.dart';
import 'package:flutter_dynamic_weather/net/weather_api.dart';
import 'package:flutter_dynamic_weather/views/app/flutter_app.dart';
import 'package:flutter_dynamic_weather/views/common/loading_view.dart';
import 'package:flutter_dynamic_weather/views/pages/search/hot_city_view.dart';
import 'package:flutter_dynamic_weather/views/pages/search/search_app_bar.dart';
import 'package:flutter_dynamic_weather/views/pages/search/search_list_view.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool _hotViewVisible = true;
  bool _searchListVisible = false;
  List<CityData>? _cityData;
  AppWidgetState _state = AppWidgetState.loading;
  List<CityModel>? cityModels;
  String? _keyWords;

  Future<bool> _dealBack() async {
    if (cityModels == null || cityModels!.isEmpty) {
      SystemNavigator.pop(animated: true);
    } else {
      if (mounted) Navigator.of(context).pop();
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    _loadCities();
  }

  Future<void> _loadCities() async {
    cityModels = await SPUtil.getCityModels();
  }

  Future<void> fetchCityData(String keywords) async {
    setState(() {
      _searchListVisible = true;
      _state = AppWidgetState.loading;
    });
    final List<CityData> cityData = [];
    final result = await WeatherApi().searchCity(keywords);
    weatherPrint("search result $result");
    if (keywords != _keyWords) return;
    if (result == null) {
      weatherPrint("搜索失败");
      if (!mounted) return;
      setState(() {
        _state = AppWidgetState.error;
        _searchListVisible = false;
      });
    } else {
      final districts = result.districts;
      if (districts != null && districts.isNotEmpty) {
        for (final element in districts) {
          if (element.level == CityData.cityLevel ||
              element.level == CityData.districtLevel) {
            cityData.add(CityData(element.name ?? "", element.center ?? "",
                level: element.level ?? ""));
          }
          final subs = element.districts;
          if (subs != null && subs.isNotEmpty) {
            for (final sub in subs) {
              if (sub.level == CityData.cityLevel ||
                  sub.level == CityData.districtLevel) {
                cityData.add(CityData(sub.name ?? "", sub.center ?? "",
                    level: sub.level ?? ""));
              }
            }
          }
        }
      } else if (result.info == "INVALID_REQUEST") {
        weatherPrint("高德 API 调用次数上限");
        if (mounted) {
          ToastUtils.show("由于高德 API 调用次数上限，无法搜索，请见谅", context,
              duration: 5);
        }
      }
    }
    if (!mounted) return;
    if (cityData.isEmpty) {
      setState(() {
        _state = AppWidgetState.error;
      });
    } else {
      setState(() {
        _state = AppWidgetState.success;
        _cityData = cityData;
      });
    }
  }

  Widget _buildSearchContent() {
    weatherPrint("创建搜索内容 state: $_state");
    if (_state == AppWidgetState.loading) {
      return const StateView();
    } else if (_state == AppWidgetState.error) {
      return const StateView(weatherState: ViewState.error);
    } else {
      return SearchListView(
        cityData: _cityData ?? const [],
        itemClickCallback: (data) {
          onItemClick(data, true);
        },
        cityModels: cityModels ?? const [],
      );
    }
  }

  CityModel _buildDefault() {
    return CityModel(
      latitude: 39.904989,
      longitude: 116.405285,
      country: "中国",
      province: "北京市",
      district: "东城区",
      displayedName: "北京市",
    );
  }

  Future<void> onItemClick(CityData cityData, bool fromList) async {
    showAppDialog();
    final result = await WeatherApi().reGeo(cityData.center);
    weatherPrint("item click regeo result: $result");
    if (!mounted) return;
    if (result == null) {
      Navigator.of(context).pop();
      ToastUtils.show("添加失败请重试", context);
      return;
    }
    var cityModel = await parseCityModel(result, cityData);
    if (cityModel == null) {
      if (mounted) {
        ToastUtils.show("高德 API 调用上限, 默认添加北京，请见谅", context, duration: 5);
      }
      cityModel = _buildDefault();
    } else {
      if (fromList) {
        cityModel.displayedName = WeatherUtils.getCityName(cityModel);
      } else {
        cityModel.displayedName = cityData.name;
      }
    }
    if (!mounted) return;
    context.read<CityBloc>().add(InsertCityData(cityModel));
    await Future.delayed(const Duration(milliseconds: 20));
    if (!mounted) return;
    Navigator.of(context).pop();
    await Future.delayed(const Duration(milliseconds: 20));
    if (!mounted) return;
    Navigator.of(context).pop();
    await Future.delayed(const Duration(milliseconds: 200));
    eventBus.fire(ChangeCityEvent(cityModel.cityFlag));
    eventBus.fire(UpdateManagerData());
  }

  static Future<CityModel?> parseCityModel(
      dynamic result, CityData cityData) async {
    if (result is! Map) return null;
    final regeo = result["regeocode"];
    if (regeo is! Map) return null;
    final addressComponent = regeo["addressComponent"];
    if (addressComponent is! Map) return null;
    final cityModel = CityModel();
    final parts = LocationUtil.parseFlag(cityData.center);
    if (parts.length >= 2) {
      cityModel.longitude = double.tryParse(parts[0]);
      cityModel.latitude = double.tryParse(parts[1]);
    }
    cityModel.country = addressComponent["country"] as String?;
    cityModel.province = addressComponent["province"] as String?;
    cityModel.district = addressComponent["district"] as String?;
    final cityRaw = addressComponent["city"];
    if (cityRaw is String) cityModel.city = cityRaw;
    return cityModel;
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          await _dealBack();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: EdgeInsets.only(top: topPad),
          child: Column(
            children: [
              SearchAppBar(
                (value) async {
                  _keyWords = value;
                  if (value == null || value.isEmpty) {
                    setState(() {
                      _hotViewVisible = true;
                      _searchListVisible = false;
                    });
                  } else {
                    setState(() {
                      _hotViewVisible = false;
                    });
                    await Future.delayed(const Duration(milliseconds: 500));
                    fetchCityData(value);
                  }
                },
                cancelTapCallback: () => _dealBack(),
                searchTapCallback: (keywords) {
                  fetchCityData(keywords);
                },
              ),
              Stack(
                children: [
                  Visibility(
                    visible: _hotViewVisible,
                    child: HotCityView(
                      itemClickCallback: (data) => onItemClick(data, false),
                    ),
                  ),
                  Visibility(
                    visible: _searchListVisible,
                    child: _buildSearchContent(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
