import 'package:flutter/material.dart';
import 'package:flutter_dynamic_weather/app/utils/print_utils.dart';
import 'package:flutter_dynamic_weather/event/change_index_envent.dart';
import 'package:flutter_dynamic_weather/model/city_data.dart';
import 'package:flutter_dynamic_weather/model/city_model_entity.dart';
import 'package:flutter_dynamic_weather/views/app/flutter_app.dart';
import 'package:flutter_dynamic_weather/views/pages/search/search_app_bar.dart';
import 'package:flutter_dynamic_weather/views/pages/search/search_page.dart';

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
              .top - 30;
      return Container(
        height: searchWidgetHeight,
        alignment: Alignment.topLeft,
        child: ListView.builder(
          itemBuilder: (_, index) {
            return Card(
              child: InkWell(
                child: Container(
                  alignment: Alignment.centerLeft,
                  height: 60,
                  margin: EdgeInsets.only(left: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text("${cityData[index].name}"),
                      ),
                      Text("${isAdd(cityData[index]) ? "已添加" : ""}"),
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
          itemCount: cityData.length,
          physics: BouncingScrollPhysics(),
        ),
      );
    }
    return Container();
  }
}
