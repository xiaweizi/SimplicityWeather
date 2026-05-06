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
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_weather_bg/flutter_weather_bg.dart';

class ManagerPage extends StatefulWidget {
  const ManagerPage({super.key});

  @override
  State<ManagerPage> createState() => _ManagerPageState();
}

class _ManagerPageState extends State<ManagerPage> {
  List<ManagerData>? _managerData;
  StreamSubscription? _subscription;

  Future<void> fetchData() async {
    weatherPrint("开始获取城市列表数据");
    final List<ManagerData> managerData = [];
    final cityModels = await SPUtil.getCityModels();
    final allWeatherData = await SPUtil.getAllWeatherModels();
    if (cityModels != null &&
        cityModels.isNotEmpty &&
        allWeatherData != null &&
        allWeatherData.isNotEmpty) {
      for (final element in cityModels) {
        final key = LocationUtil.convertCityFlag(
            element.cityFlag, element.isLocated ?? false);
        if (allWeatherData.containsKey(key)) {
          final modelStr = allWeatherData[key];
          if (modelStr == null || modelStr.isEmpty) continue;
          final entity = WeatherModelEntity().fromJson(json.decode(modelStr));
          final realtime = entity.result?.realtime;
          final daily = entity.result?.daily;
          String currentTemperature = "";
          if (realtime?.temperature != null) {
            currentTemperature = "${realtime!.temperature}°";
          }
          final todayTemperature = WeatherUtils.getTemperatureDesc(daily);
          WeatherType weatherType = WeatherType.sunny;
          String weatherDesc = "";
          if (realtime != null) {
            weatherType = WeatherUtils.convertWeatherType(realtime.skycon);
            weatherDesc = WeatherUtils.convertDesc(realtime.skycon);
          }
          managerData.add(ManagerData(
            cityFlag: element.cityFlag,
            isLocated: element.isLocated ?? false,
            cityName: element.displayedName ?? "",
            currentTemperature: currentTemperature,
            todayTemperature: todayTemperature,
            weatherType: weatherType,
            weatherDesc: weatherDesc,
          ));
        }
      }
    }
    weatherPrint("获取城市管理列表数据成功 length: ${managerData.length}");
    if (!mounted) return;
    setState(() {
      _managerData = managerData;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    _subscription = eventBus.on<UpdateManagerData>().listen((event) async {
      await Future.delayed(const Duration(milliseconds: 500));
      fetchData();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Widget _buildAppBar() => SizedBox(
        height: kToolbarHeight,
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 6),
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios,
                    color: Colors.black54, size: 20),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            const Align(
              child: Text("城市管理", style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      );

  Widget _buildManagerContent() {
    final data = _managerData;
    if (data == null) return const SizedBox.shrink();
    final mq = MediaQuery.of(context);
    final managerWidgetHeight =
        mq.size.height - kToolbarHeight - mq.padding.top - kToolbarHeight - 30;
    return SizedBox(
      height: managerWidgetHeight,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView.separated(
          itemCount: data.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, index) => Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
            child: _buildItemWidget(data[index]),
          ),
        ),
      ),
    );
  }

  Widget _buildItemContentWidget(ManagerData data) {
    const radius = 20.0;
    return ClipPath(
      clipper: ShapeBorderClipper(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius))),
      child: Stack(
        children: [
          WeatherBg(
            weatherType: data.weatherType,
            width: MediaQuery.of(context).size.width,
            height: 100,
          ),
          SizedBox(
            height: 100,
            child: Row(
              children: [
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            data.weatherDesc,
                            style: const TextStyle(
                              color: Color.fromARGB(200, 255, 255, 255),
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            data.todayTemperature,
                            style: const TextStyle(
                              color: Color.fromARGB(200, 255, 255, 255),
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            data.cityName,
                            style: const TextStyle(
                              color: Color.fromARGB(250, 255, 255, 255),
                              fontWeight: FontWeight.w400,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Visibility(
                            visible: data.isLocated == true,
                            child: const Icon(Icons.location_on,
                                color: Colors.white, size: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  data.currentTemperature,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 40,
                  ),
                ),
                const SizedBox(width: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemWidget(ManagerData data) {
    Widget content = GestureDetector(
      onTap: () {
        eventBus.fire(ChangeCityEvent(data.cityFlag));
        Navigator.of(context).pop();
      },
      child: _buildItemContentWidget(data),
    );

    if (data.isLocated != true) {
      content = Slidable(
        key: ValueKey(data.cityFlag),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.25,
          children: [
            SlidableAction(
              onPressed: (_) => deleteCity(data),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: '删除',
            ),
          ],
        ),
        child: content,
      );
    }
    return ClipPath(
      clipper: ShapeBorderClipper(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
      child: content,
    );
  }

  Future<void> deleteCity(ManagerData managerData) async {
    _managerData?.remove(managerData);
    setState(() {});
    if (!mounted) return;
    context.read<CityBloc>().add(DeleteCityData(managerData.cityFlag));
  }

  Widget _buildSearchView() {
    return Container(
      padding: const EdgeInsets.only(
        top: 6,
        bottom: 6,
        left: DimenConstant.mainMarginStartEnd,
        right: DimenConstant.mainMarginStartEnd,
      ),
      height: kToolbarHeight,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pushNamed(WeatherRouter.search),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0x30cccccc),
            borderRadius: BorderRadius.all(Radius.circular(100)),
          ),
          child: Row(
            children: const [
              SizedBox(width: 20),
              Icon(Icons.search, color: Colors.grey),
              SizedBox(width: 10),
              Text(
                "搜索城市天气",
                style: TextStyle(fontSize: 16, color: Color(0xA0000000)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Container(
          padding: EdgeInsets.only(top: topPad),
          child: Column(
            children: [
              _buildAppBar(),
              _buildSearchView(),
              _buildManagerContent(),
            ],
          ),
        ),
      ),
    );
  }
}

class ManagerData extends Equatable {
  final String cityFlag;
  final String cityName;
  final String todayTemperature;
  final String currentTemperature;
  final bool isLocated;
  final WeatherType weatherType;
  final String weatherDesc;

  const ManagerData({
    required this.cityFlag,
    required this.cityName,
    required this.todayTemperature,
    required this.currentTemperature,
    required this.isLocated,
    required this.weatherType,
    required this.weatherDesc,
  });

  @override
  String toString() =>
      'ManagerData{flag:$cityFlag, name:$cityName, type:$weatherType}';

  @override
  List<Object?> get props => [cityFlag];
}
