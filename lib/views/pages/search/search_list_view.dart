import 'package:flutter/material.dart';
import 'package:flutter_dynamic_weather/app/utils/print_utils.dart';
import 'package:flutter_dynamic_weather/event/change_index_envent.dart';
import 'package:flutter_dynamic_weather/model/city_data.dart';
import 'package:flutter_dynamic_weather/model/city_model_entity.dart';
import 'package:flutter_dynamic_weather/views/app/flutter_app.dart';
import 'package:flutter_dynamic_weather/views/pages/search/search_app_bar.dart';
import 'package:flutter_dynamic_weather/views/pages/search/search_page.dart';
import 'package:flutter_weather_bg/flutter_weather_bg.dart';

class SearchListView extends StatelessWidget {
  final List<CityData> cityData;
  final CityItemClickCallback itemClickCallback;
  final List<CityModel> cityModels;

  SearchListView({Key key, this.cityData, this.itemClickCallback, this.cityModels}) : super(key: key);

  bool isAdd(CityData cityData) {
    bool isAdd = false;
    if (cityModels != null && cityModels.isNotEmpty && cityData != null) {
      cityModels.forEach((element) {
        if (element.cityFlag == cityData.center) {
          isAdd = true;
        }
      });
    }
    return isAdd;
  }

  @override
  Widget build(BuildContext context) {
    if (cityData != null && cityData.isNotEmpty) {
      weatherPrint("SearchListView || ${cityData.length}");
      var searchWidgetHeight = MediaQuery.of(context).size.height -
          kToolbarHeight -
          MediaQueryData.fromWindow(WidgetsBinding.instance.window)
              .padding
              .top - 10;
      return Container(
        height: searchWidgetHeight,
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: ListView.separated(
          itemBuilder: (_, index) {
            return Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: GestureDetector(
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: WeatherUtil.getColor(WeatherType.sunny),
                        stops: [0, 1],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      )),
                  child: Row(
                    children: [
                      SizedBox(width: 20),
                      Expanded(
                        child: Text("${cityData[index].name}", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
                      ),
                      Text("${isAdd(cityData[index]) ? "已添加" : ""}", style: TextStyle(color: Colors.white, fontSize: 14),),
                      SizedBox(
                        width: 16,
                      )
                    ],
                  ),
                ),
                onTap: () {
                  if (isAdd(cityData[index])) {
                    eventBus.fire(ChangeCityEvent(cityData[index].center));
                    Navigator.of(context).pop();
                  } else if (itemClickCallback != null) {
                    itemClickCallback(cityData[index]);
                  }
                },
              ),
            );
          },
          separatorBuilder: (_, index) => SizedBox(height: 10,),
          itemCount: cityData.length,
          physics: BouncingScrollPhysics(),
        ),
      );
    }
    return Container();
  }
}
