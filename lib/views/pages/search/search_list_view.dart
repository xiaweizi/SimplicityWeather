import 'package:flutter/material.dart';
import 'package:flutter_dynamic_weather/app/utils/print_utils.dart';
import 'package:flutter_dynamic_weather/event/change_index_envent.dart';
import 'package:flutter_dynamic_weather/model/city_data.dart';
import 'package:flutter_dynamic_weather/model/city_model_entity.dart';
import 'package:flutter_dynamic_weather/views/app/flutter_app.dart';
import 'package:flutter_dynamic_weather/views/pages/search/search_app_bar.dart';
import 'package:flutter_weather_bg/flutter_weather_bg.dart';

class SearchListView extends StatelessWidget {
  final List<CityData> cityData;
  final CityItemClickCallback? itemClickCallback;
  final List<CityModel> cityModels;

  const SearchListView({
    super.key,
    required this.cityData,
    this.itemClickCallback,
    required this.cityModels,
  });

  bool isAdd(CityData cityData) {
    if (cityModels.isEmpty) return false;
    for (final element in cityModels) {
      if (element.cityFlag == cityData.center) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (cityData.isEmpty) return const SizedBox.shrink();
    weatherPrint("SearchListView || ${cityData.length}");
    final mq = MediaQuery.of(context);
    final searchWidgetHeight =
        mq.size.height - kToolbarHeight - mq.padding.top - 10;
    return SizedBox(
      height: searchWidgetHeight,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView.separated(
          itemBuilder: (_, index) {
            final data = cityData[index];
            final added = isAdd(data);
            return Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: GestureDetector(
                onTap: () {
                  if (added) {
                    eventBus.fire(ChangeCityEvent(data.center));
                    Navigator.of(context).pop();
                  } else {
                    itemClickCallback?.call(data);
                  }
                },
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: WeatherUtil.getColor(WeatherType.sunny),
                      stops: const [0, 1],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          data.name,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        added ? "已添加" : "",
                        style: const TextStyle(
                            color: Colors.white, fontSize: 14),
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemCount: cityData.length,
          physics: const BouncingScrollPhysics(),
        ),
      ),
    );
  }
}
