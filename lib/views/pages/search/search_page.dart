import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dynamic_weather/app/res/analytics_constant.dart';
import 'package:flutter_dynamic_weather/app/res/dimen_constant.dart';
import 'package:flutter_dynamic_weather/app/res/weather_type.dart';
import 'package:flutter_dynamic_weather/app/res/widget_state.dart';
import 'package:flutter_dynamic_weather/app/router.dart';
import 'package:flutter_dynamic_weather/app/utils/location_util.dart';
import 'package:flutter_dynamic_weather/app/utils/print_utils.dart';
import 'package:flutter_dynamic_weather/app/utils/shared_preference_util.dart';
import 'package:flutter_dynamic_weather/app/utils/toast.dart';
import 'package:flutter_dynamic_weather/bloc/city/city_bloc.dart';
import 'package:flutter_dynamic_weather/event/change_index_envent.dart';
import 'package:flutter_dynamic_weather/model/city_data.dart';
import 'package:flutter_dynamic_weather/model/city_model_entity.dart';
import 'package:flutter_dynamic_weather/model/district_model_entity.dart';
import 'package:flutter_dynamic_weather/net/weather_api.dart';
import 'package:flutter_dynamic_weather/views/app/flutter_app.dart';
import 'package:flutter_dynamic_weather/views/common/loading_dialog.dart';
import 'package:flutter_dynamic_weather/views/common/loading_view.dart';
import 'package:flutter_dynamic_weather/views/pages/search/hot_city_view.dart';
import 'package:flutter_dynamic_weather/views/pages/search/search_app_bar.dart';
import 'package:flutter_dynamic_weather/views/pages/search/search_list_view.dart';
import 'package:umeng_analytics_plugin/umeng_analytics_plugin.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool _hotViewVisible = true;
  bool _searchListVisible = false;
  List<CityData> _cityData;
  WidgetState _state;
  List<CityModel> cityModels;
  String _keyWords;

  Future<bool> _dealBack() async {
    if (cityModels == null || cityModels.isEmpty) {
      SystemNavigator.pop(animated: true);
    } else {
      Navigator.of(context).pop();
    }
    return false;
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    cityModels = await SPUtil.getCityModels();
  }

  Future<void> fetchCityData(keywords) async {
    setState(() {
      _searchListVisible = true;
      _state = WidgetState.loading;
    });
    List<CityData> cityData = [];
    var result = await WeatherApi().searchCity(keywords);
    if (keywords != _keyWords) {
      return;
    }
    if (result == null) {
      // 请求失败
      weatherPrint("搜索失败");
      setState(() {
        _state = WidgetState.error;
        _searchListVisible = false;
      });
    } else {
      if (result.districts != null && result.districts.isNotEmpty) {
        UmengAnalyticsPlugin.event(AnalyticsConstant.cityTotalCount, label: "$keywords");
        result.districts.forEach((element) {
          if (element.level == CityData.cityLevel ||
              element.level == CityData.districtLevel) {
            cityData.add(
                CityData(element.name, element.center, level: element.level));
          }
          var districts = element.districts;
          if (districts != null && districts.isNotEmpty) {
            districts.forEach((element) {
              if (element.level == CityData.cityLevel ||
                  element.level == CityData.districtLevel) {
                cityData.add(CityData(element.name, element.center,
                    level: element.level));
              }
            });
          }
        });
      }
    }
    if (cityData.isEmpty) {
      // 未搜索到
      weatherPrint("未搜到数据");
      setState(() {
        _state = WidgetState.error;
      });
    } else {
      // 搜索成功
      weatherPrint("搜索成功 $cityData");
      setState(() {
        _state = WidgetState.success;
        _cityData = cityData;
      });
    }
  }

  Widget _buildSearchContent() {
    weatherPrint("创建搜索内容 state: $_state");
    if (_state == WidgetState.loading) {
      return StateView(isDark: true);
    } else if (_state == WidgetState.error) {
      return Container(
        child: StateView(isDark: true, weatherState: ViewState.error,),
      );
    } else {
      return SearchListView(
        cityData: _cityData,
        itemClickCallback: (data){
          onItemClick(data, true);
        },
        cityModels: cityModels,
      );
    }
  }

  Future<void> onItemClick(CityData cityData, bool fromList) async {
    showAppDialog();
    var result = await WeatherApi().reGeo(cityData.center);
    if (result == null) {
      Navigator.of(context).pop();
      ToastUtils.show("添加失败请重试", context);
      return;
    }
    CityModel cityModel = await parseCityModel(result, cityData);
    if (fromList) {
      cityModel.displayedName = "${WeatherUtil.getCityName(cityModel)}";
    } else {
      cityModel.displayedName = cityData.name;
    }
    BlocProvider.of<CityBloc>(context).add(InsertCityData(cityModel));
    await Future.delayed(Duration(milliseconds: 20));
    Navigator.of(context).pop();
    await Future.delayed(Duration(milliseconds: 20));
    Navigator.of(context).pop();
    await Future.delayed(Duration(milliseconds: 200));
    eventBus.fire(ChangeCityEvent(cityModel.cityFlag));
    eventBus.fire(UpdateManagerData());
  }

  static Future<CityModel> parseCityModel(result, CityData cityData) async {
    CityModel cityModel = CityModel();
    if (result["regeocode"] != null &&
        result["regeocode"]["addressComponent"] != null) {
      var addressComponent = result["regeocode"]["addressComponent"];

      cityModel.longitude =
          double.parse(LocationUtil.parseFlag(cityData.center)[0]);
      cityModel.latitude =
          double.parse(LocationUtil.parseFlag(cityData.center)[1]);
      cityModel.country = addressComponent["country"];
      cityModel.province = addressComponent["province"];
      cityModel.district = addressComponent["district"];
      if (addressComponent["city"] != null &&
          addressComponent["city"] is String) {
        cityModel.city = addressComponent["city"];
      }
    }
    return cityModel;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            padding: EdgeInsets.only(
                top: MediaQueryData.fromWindow(WidgetsBinding.instance.window)
                    .padding
                    .top),
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
                      await Future.delayed(Duration(milliseconds: 500));
                      fetchCityData(value);
                    }
                  },
                  cancelTapCallback: () {
                    _dealBack();
                  },
                  searchTapCallback: (keywords) {
                    fetchCityData(keywords);
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Stack(
                  children: [
                    Visibility(
                      visible: _hotViewVisible,
                      child: HotCityView(
                        itemClickCallback: (data){
                          onItemClick(data, false);
                        },
                      ),
                    ),
                    Visibility(
                      visible: _searchListVisible,
                      child: _buildSearchContent(),
                    )
                  ],
                ),
              ],
            ),
          )),
      onWillPop: _dealBack,
    );
  }
}
