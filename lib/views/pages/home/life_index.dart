import 'package:flutter/material.dart';
import 'package:flutter_dynamic_weather/app/res/analytics_constant.dart';
import 'package:flutter_dynamic_weather/app/res/dimen_constant.dart';
import 'package:flutter_dynamic_weather/app/res/weather_type.dart';
import 'package:flutter_dynamic_weather/app/utils/color_utils.dart';
import 'package:flutter_dynamic_weather/app/utils/print_utils.dart';
import 'package:flutter_dynamic_weather/app/utils/time_util.dart';
import 'package:flutter_dynamic_weather/model/weather_model_entity.dart';
import 'package:flutter_dynamic_weather/app/res/common_extension.dart';
import 'package:flutter_dynamic_weather/views/common/blur_rect.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:umeng_analytics_plugin/umeng_analytics_plugin.dart';
import 'package:url_launcher/url_launcher.dart';

class LifeIndexView extends StatelessWidget {
  List<LifeIndexDetail> lifeIndexDetail = [];
  WeatherModelResultDailyLifeIndex modelResultDailyLifeIndex;
  final String skycon;

  LifeIndexView({Key key, this.modelResultDailyLifeIndex, this.skycon})
      : super(key: key) {
    if (modelResultDailyLifeIndex != null) {
      if (modelResultDailyLifeIndex.ultraviolet != null &&
          modelResultDailyLifeIndex.ultraviolet.isNotEmpty) {
        modelResultDailyLifeIndex.ultraviolet.forEach((element) {
          var time = element.date.dateTime;
          var now = DateTime.now();
          if (time.day == now.day) {
            lifeIndexDetail.add(LifeIndexDetail(
                LifeIndexType.ultraviolet, element.desc, element.date));
          }
        });
        modelResultDailyLifeIndex.carWashing.forEach((element) {
          var time = element.date.dateTime;
          var now = DateTime.now();
          if (time.day == now.day) {
            lifeIndexDetail.add(LifeIndexDetail(
                LifeIndexType.carWashing, element.desc, element.date));
          }
        });
        modelResultDailyLifeIndex.dressing.forEach((element) {
          var time = element.date.dateTime;
          var now = DateTime.now();
          if (time.day == now.day) {
            lifeIndexDetail.add(LifeIndexDetail(
                LifeIndexType.dressing, element.desc, element.date));
          }
        });
        modelResultDailyLifeIndex.comfort.forEach((element) {
          var time = element.date.dateTime;
          var now = DateTime.now();
          if (time.day == now.day) {
            lifeIndexDetail.add(LifeIndexDetail(
                LifeIndexType.comfort, element.desc, element.date));
          }
        });
        modelResultDailyLifeIndex.coldRisk.forEach((element) {
          var time = element.date.dateTime;
          var now = DateTime.now();
          if (time.day == now.day) {
            lifeIndexDetail.add(LifeIndexDetail(
                LifeIndexType.coldRisk, element.desc, element.date));
          }
        });
        lifeIndexDetail.add(LifeIndexDetail(
            LifeIndexType.typhoon, "详情", ""));
      }
    }
  }

  Widget _buildBottomSheetIndexItem(BuildContext context, LifeIndexDetail detail) {
    String showTime =
        "${TimeUtil.getWeatherDayDesc(detail.date)}";
    return GestureDetector(
      child: Container(
        child: Column(
          children: <Widget>[
            Image.asset(
              WeatherUtil.getLifeIndexIcon(detail.type),
              width: 30,
              height: 30,
              color: Colors.white,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              detail.desc,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              showTime,
              style: TextStyle(color: Colors.white54, fontSize: 13),
            ),
          ],
        ),
      )
    );
  }

  Widget _buildLifeIndexItem(BuildContext context, LifeIndexDetail detail) {
    return InkWell(
      child: Container(
        child: Column(
          children: <Widget>[
            Image.asset(
              WeatherUtil.getLifeIndexIcon(detail.type),
              width: 30,
              height: 30,
              color: Colors.white,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              detail.desc,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              WeatherUtil.getLifeIndexDesc(detail.type),
              style: TextStyle(color: Colors.white54, fontSize: 13),
            ),
          ],
        ),
      ),
      onTap: () {
        if (detail.type != LifeIndexType.typhoon) {
          UmengAnalyticsPlugin.event(AnalyticsConstant.bottomSheet, label: "生活指数");
          showMaterialModalBottomSheet(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            ),
            backgroundColor: Colors.transparent,
            context: context,
            builder: (context, scrollController) => BlurRectWidget(
              color: WeatherUtil.getColor(WeatherUtil.convertWeatherType(skycon))[0].withAlpha(60),
              child: Container(
                height: 0.5.hp,
                child: _buildSheetWidget(context, detail.type),
              ),
            ),
          );
        } else {
          UmengAnalyticsPlugin.event(AnalyticsConstant.bottomSheet, label: "台风路径");
          _launchURL();
        }
      },
    );
  }

  _launchURL() async {
    const url = 'http://typhoon.zjwater.gov.cn/wap.htm';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  Widget _buildSheetWidget(BuildContext context, LifeIndexType lifeIndexType) {
    List<LifeIndexDetail> detail = [];
    if (modelResultDailyLifeIndex != null) {
      if (modelResultDailyLifeIndex.ultraviolet != null &&
          modelResultDailyLifeIndex.ultraviolet.isNotEmpty) {
        if (lifeIndexType == LifeIndexType.ultraviolet) {
          modelResultDailyLifeIndex.ultraviolet.forEach((element) {
            detail.add(LifeIndexDetail(
                LifeIndexType.ultraviolet, element.desc, element.date));
          });
        }
        if (lifeIndexType == LifeIndexType.carWashing) {
          modelResultDailyLifeIndex.carWashing.forEach((element) {
            detail.add(LifeIndexDetail(
                LifeIndexType.carWashing, element.desc, element.date));
          });
        }
        if (lifeIndexType == LifeIndexType.dressing) {
          modelResultDailyLifeIndex.dressing.forEach((element) {
            detail.add(LifeIndexDetail(
                LifeIndexType.dressing, element.desc, element.date));
          });
        }
        if (lifeIndexType == LifeIndexType.comfort) {
          modelResultDailyLifeIndex.comfort.forEach((element) {
            detail.add(LifeIndexDetail(
                LifeIndexType.comfort, element.desc, element.date));
          });
        }
        if (lifeIndexType == LifeIndexType.coldRisk) {
          modelResultDailyLifeIndex.coldRisk.forEach((element) {
            detail.add(LifeIndexDetail(
                LifeIndexType.coldRisk, element.desc, element.date));
          });
        }
      }
    }
    var width = 1.0.wp / 3;
    var height = (0.5.hp - 30) / 2;
    var ratio = width / height;
    weatherPrint("bottomSheet width: $width, height: $height, ratio: $ratio");
    return Container(
      margin: EdgeInsets.only(top: 30),
      child: GridView.count(
        childAspectRatio: ratio,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        children: detail
            .map((e) => _buildBottomSheetIndexItem(context, e))
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var itemWidth = (1.wp - DimenConstant.mainMarginStartEnd * 2) / 3 * 5 / 4;
    return BlurRectWidget(
      child: Container(
        height: itemWidth * (1 + 1),
        child: GridView.count(
          childAspectRatio: 4.0 / 5,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          children: lifeIndexDetail
              .map((e) => _buildLifeIndexItem(context, e))
              .toList(),
        ),
      ),
    );
  }
}

class LifeIndexDetail {
  LifeIndexType type;
  String desc;
  String date;

  LifeIndexDetail(this.type, this.desc, this.date);
}
