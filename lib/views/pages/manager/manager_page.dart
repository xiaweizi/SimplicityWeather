import 'dart:async';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dynamic_weather/app/res/dimen_constant.dart';
import 'package:flutter_dynamic_weather/app/res/weather_type.dart';
import 'package:flutter_dynamic_weather/app/router.dart';
import 'package:flutter_dynamic_weather/app/utils/location_util.dart';
import 'package:flutter_dynamic_weather/app/utils/print_utils.dart';
import 'package:flutter_dynamic_weather/app/utils/shared_preference_util.dart';
import 'package:flutter_dynamic_weather/bloc/city/city_bloc.dart';
import 'package:flutter_dynamic_weather/event/change_index_envent.dart';
import 'package:flutter_dynamic_weather/model/city_model_entity.dart';
import 'package:flutter_dynamic_weather/model/weather_model_entity.dart';
import 'package:flutter_dynamic_weather/views/app/flutter_app.dart';
import 'package:flutter_dynamic_weather/views/bg/weather_cloud_bg.dart';
import 'package:flutter_dynamic_weather/views/bg/weather_color_bg.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ManagerPage extends StatefulWidget {
  @override
  _ManagerPageState createState() => _ManagerPageState();
}

class _ManagerPageState extends State<ManagerPage> {
  List<ManagerData> _managerData;
  StreamSubscription _subscription;

  Future<void> fetchData() async {
    weatherPrint("开始获取城市列表数据");
    List<ManagerData> managerData = [];
    List<CityModel> cityModels = await SPUtil.getCityModels();
    Map<String, String> allWeatherData = await SPUtil.getAllWeatherModels();
    if (cityModels != null &&
        cityModels.isNotEmpty &&
        allWeatherData != null &&
        allWeatherData.isNotEmpty) {
      cityModels.forEach((element) {
        String key =
            "${LocationUtil.convertCityFlag(element.cityFlag, element.isLocated)}";
        if (allWeatherData.containsKey(key)) {
          var modelStr = allWeatherData[key];
          if (modelStr != null && modelStr.isNotEmpty) {
            WeatherModelEntity weatherModelEntity =
                WeatherModelEntity().fromJson(json.decode(modelStr));
            String currentTemperature = "";
            if (weatherModelEntity != null &&
                weatherModelEntity.result != null &&
                weatherModelEntity.result.realtime != null) {
              currentTemperature =
                  "${weatherModelEntity.result.realtime.temperature}°";
            }
            String todayTemperature = "";
            if (weatherModelEntity != null &&
                weatherModelEntity.result != null &&
                weatherModelEntity.result.daily != null) {
              todayTemperature =
                  "${WeatherUtil.getTemperatureDesc(weatherModelEntity.result.daily)}";
            }
            WeatherType weatherType = WeatherType.sunny;
            if (weatherModelEntity != null &&
                weatherModelEntity.result != null &&
                weatherModelEntity.result.realtime != null) {
              weatherType = WeatherUtil.convertWeatherType(weatherModelEntity.result.realtime.skycon);
            }
            String weatherDesc = "";
            if (weatherModelEntity != null &&
                weatherModelEntity.result != null &&
                weatherModelEntity.result.realtime != null) {
              weatherDesc = WeatherUtil.convertDesc(weatherModelEntity.result.realtime.skycon);
            }
            managerData.add(ManagerData(
              cityFlag: element.cityFlag,
              isLocated: element.isLocated,
              cityName: element.displayedName,
              currentTemperature: currentTemperature,
              todayTemperature: todayTemperature,
              weatherType: weatherType,
              weatherDesc: weatherDesc,
            ));
          }
        }
      });
    }
    weatherPrint("获取城市管理列表数据成功 length: ${managerData.length} data: $managerData");
//    managerData[0].weatherType = WeatherType.lightSnow;
//    managerData[1].weatherType = WeatherType.middleSnow;
//    managerData[2].weatherType = WeatherType.heavySnow;
//    managerData[3].weatherType = WeatherType.hazy;
//    managerData[4].weatherType = WeatherType.foggy;
//    managerData[5].weatherType = WeatherType.dusty;
    setState(() {
      _managerData = managerData;
    });
  }

  @override
  void initState() {
    fetchData();
    _subscription = eventBus.on<UpdateManagerData>().listen((event) async {
      await Future.delayed(Duration(milliseconds: 500));
      fetchData();
    });
    super.initState();
  }


  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  Widget _buildAppBar() => Container(
      height: kToolbarHeight,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(left: 6),
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black54,
                size: 20,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Align(
            child: Text(
              "城市管理",
              style: TextStyle(fontSize: 20),
            ),
          )
        ],
      ));

  Widget _buildManagerContent() {
    if (_managerData != null) {
      var managerWidgetHeight = MediaQuery.of(context).size.height -
          kToolbarHeight -
          MediaQueryData.fromWindow(WidgetsBinding.instance.window)
              .padding
              .top -
          kToolbarHeight -
          30;
      return Container(
        height: managerWidgetHeight,
        margin: EdgeInsets.only(left: 20, right: 20),
        child: ListView.builder(
            itemCount: _managerData.length,
            itemBuilder: (_, index) => _buildItemWidget(_managerData[index])),
      );
    }
    return Container();
  }

  Widget _buildItemContentWidget(ManagerData data) => Stack(
        children: [
          WeatherColorBg(weatherType: data.weatherType, height: 100,),
          Container(
            height: 100,
            child: Row(
              children: [
                SizedBox(
                  width: 14,
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "${data.weatherDesc}",
                            style: TextStyle(
                                color: Color.fromARGB(200, 255, 255, 255),
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1,
                                fontSize: 12),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "${data.todayTemperature}",
                            style: TextStyle(
                                color: Color.fromARGB(200, 255, 255, 255),
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1,
                                fontSize: 12),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Text(
                            "${data.cityName}",
                            style: TextStyle(
                                color: Color.fromARGB(250, 255, 255, 255),
                                fontWeight: FontWeight.w400,
                                fontSize: 18),
                          ),
                          SizedBox(width: 6,),
                          Visibility(
                            visible: data.isLocated == true,
                            child: Icon(Icons.location_on, color: Colors.white, size: 18,),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  "${data.currentTemperature}",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 40),
                ),
                SizedBox(
                  width: 20,
                )
              ],
            ),
          ),
        ],
      );

  Widget _buildItemWidget(ManagerData data) {
    if (data.isLocated != true) {
      return Container(
        padding: EdgeInsets.only(bottom: 10),
        child: ClipPath(
          child: GestureDetector(
            child: Slidable(
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.25,
              child: _buildItemContentWidget(data),
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: '删除',
                  color: Colors.red,
                  icon: Icons.delete,
                  onTap: () => {deleteCity(data)},
                ),
              ],
            ),
            onTap: () async {
              eventBus.fire(ChangeCityEvent(data.cityFlag));
              Navigator.of(context).pop();
            },
          ),
          clipper: ShapeBorderClipper(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)))),
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.only(bottom: 10),
        child: ClipPath(
          child: GestureDetector(
            child: _buildItemContentWidget(data),
            onTap: () async {
              eventBus.fire(ChangeCityEvent(data.cityFlag));
              Navigator.of(context).pop();
            },
          ),
          clipper: ShapeBorderClipper(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)))),
        ),
      );
    }
  }

  Future<void> deleteCity(ManagerData managerData) async {
    _managerData.remove(managerData);
    setState(() {});
    BlocProvider.of<CityBloc>(context)
        .add(DeleteCityData(managerData.cityFlag));
  }

  Widget _buildSearchView() {
    return Container(
      padding: EdgeInsets.only(
          top: 6,
          bottom: 6,
          left: DimenConstant.mainMarginStartEnd,
          right: DimenConstant.mainMarginStartEnd),
      height: kToolbarHeight,
      child: GestureDetector(
        child: Container(
          decoration: BoxDecoration(
            color: Color(0x30cccccc),
            borderRadius: BorderRadius.all(Radius.circular(100)),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 20,
              ),
              Icon(
                Icons.search,
                color: Colors.grey,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "搜索城市天气",
                style: TextStyle(fontSize: 16, color: Color(0xA0000000)),
              )
            ],
          ),
        ),
        onTap: () {
          Navigator.of(context).pushNamed(Router.search);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: Container(
            padding: EdgeInsets.only(
                top: MediaQueryData.fromWindow(WidgetsBinding.instance.window)
                    .padding
                    .top),
            child: Column(
              children: [
                _buildAppBar(),
                _buildSearchView(),
                _buildManagerContent(),
              ],
            ),
          ),
        ));
  }
}

class ManagerData extends Equatable {
  final String cityFlag;
  final String cityName;
  final String todayTemperature;
  final String currentTemperature;
  final bool isLocated;
  WeatherType weatherType;
  final String weatherDesc;

  ManagerData(
      {this.cityFlag,
      this.cityName,
      this.todayTemperature,
      this.currentTemperature,
      this.isLocated,
      this.weatherType,
      this.weatherDesc});


  @override
  String toString() {
    return 'ManagerData{cityFlag: $cityFlag, cityName: $cityName, todayTemperature: $todayTemperature, currentTemperature: $currentTemperature, isLocated: $isLocated, weatherType: $weatherType, weatherDesc: $weatherDesc}';
  }

  @override
  List<Object> get props => [cityFlag];
}
