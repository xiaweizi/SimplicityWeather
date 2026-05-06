import 'package:flutter/material.dart';
import 'package:flutter_dynamic_weather/app/res/common_extension.dart';
import 'package:flutter_dynamic_weather/app/res/dimen_constant.dart';
import 'package:flutter_dynamic_weather/app/res/weather_type.dart';
import 'package:flutter_dynamic_weather/app/utils/print_utils.dart';
import 'package:flutter_dynamic_weather/app/utils/time_util.dart';
import 'package:flutter_dynamic_weather/model/weather_model_entity.dart';
import 'package:flutter_dynamic_weather/views/common/blur_rect.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

class LifeIndexView extends StatelessWidget {
  final List<LifeIndexDetail> lifeIndexDetail = [];
  final WeatherModelResultDailyLifeIndex? modelResultDailyLifeIndex;
  final String? skycon;

  LifeIndexView({super.key, this.modelResultDailyLifeIndex, this.skycon}) {
    final model = modelResultDailyLifeIndex;
    if (model == null) return;
    final ultraviolet = model.ultraviolet;
    if (ultraviolet == null || ultraviolet.isEmpty) return;

    final now = DateTime.now();

    void addToday<T>(
      List<T>? items,
      LifeIndexType type,
      String? Function(T) descGetter,
      String? Function(T) dateGetter,
    ) {
      if (items == null) return;
      for (final e in items) {
        final dateStr = dateGetter(e);
        if (dateStr == null) continue;
        final time = dateStr.dateTime;
        if (time.day == now.day) {
          lifeIndexDetail.add(
              LifeIndexDetail(type, descGetter(e) ?? "", dateStr));
        }
      }
    }

    addToday<WeatherModelResultDailyLifeIndexUltraviolet>(
      ultraviolet,
      LifeIndexType.ultraviolet,
      (e) => e.desc,
      (e) => e.date,
    );
    addToday<WeatherModelResultDailyLifeIndexCarWashing>(
      model.carWashing,
      LifeIndexType.carWashing,
      (e) => e.desc,
      (e) => e.date,
    );
    addToday<WeatherModelResultDailyLifeIndexDressing>(
      model.dressing,
      LifeIndexType.dressing,
      (e) => e.desc,
      (e) => e.date,
    );
    addToday<WeatherModelResultDailyLifeIndexComfort>(
      model.comfort,
      LifeIndexType.comfort,
      (e) => e.desc,
      (e) => e.date,
    );
    addToday<WeatherModelResultDailyLifeIndexColdRisk>(
      model.coldRisk,
      LifeIndexType.coldRisk,
      (e) => e.desc,
      (e) => e.date,
    );
    lifeIndexDetail.add(LifeIndexDetail(LifeIndexType.typhoon, "详情", ""));
  }

  Widget _buildBottomSheetIndexItem(
      BuildContext context, LifeIndexDetail detail) {
    final showTime = TimeUtil.getWeatherDayDesc(detail.date);
    return Column(
      children: [
        Image.asset(
          WeatherUtils.getLifeIndexIcon(detail.type),
          width: 30,
          height: 30,
          color: Colors.white,
        ),
        const SizedBox(height: 15),
        Text(detail.desc,
            style: const TextStyle(color: Colors.white, fontSize: 16)),
        const SizedBox(height: 8),
        Text(showTime,
            style: const TextStyle(color: Colors.white54, fontSize: 13)),
      ],
    );
  }

  Widget _buildLifeIndexItem(BuildContext context, LifeIndexDetail detail) {
    return InkWell(
      onTap: () {
        if (detail.type != LifeIndexType.typhoon) {
          showMaterialModalBottomSheet(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            backgroundColor: Colors.transparent,
            context: context,
            builder: (ctx) => BlurRectWidget(
              color: WeatherUtils.getColor(
                      WeatherUtils.convertWeatherType(skycon))[0]
                  .withAlpha(60),
              child: SizedBox(
                height: 0.5.sh,
                child: _buildSheetWidget(ctx, detail.type),
              ),
            ),
          );
        } else {
          _launchTyphoonURL();
        }
      },
      child: Column(
        children: [
          Image.asset(
            WeatherUtils.getLifeIndexIcon(detail.type),
            width: 30,
            height: 30,
            color: Colors.white,
          ),
          const SizedBox(height: 15),
          Text(detail.desc,
              style: const TextStyle(color: Colors.white, fontSize: 16)),
          const SizedBox(height: 8),
          Text(
            WeatherUtils.getLifeIndexDesc(detail.type),
            style: const TextStyle(color: Colors.white54, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Future<void> _launchTyphoonURL() async {
    final uri = Uri.parse('http://typhoon.zjwater.gov.cn/wap.htm');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Widget _buildSheetWidget(BuildContext context, LifeIndexType lifeIndexType) {
    final List<LifeIndexDetail> detail = [];
    final model = modelResultDailyLifeIndex;
    if (model != null) {
      void collect<T>(
        List<T>? items,
        LifeIndexType type,
        String? Function(T) descGetter,
        String? Function(T) dateGetter,
      ) {
        if (items == null) return;
        for (final e in items) {
          detail.add(LifeIndexDetail(type, descGetter(e) ?? "",
              dateGetter(e) ?? ""));
        }
      }

      switch (lifeIndexType) {
        case LifeIndexType.ultraviolet:
          collect<WeatherModelResultDailyLifeIndexUltraviolet>(
              model.ultraviolet,
              LifeIndexType.ultraviolet,
              (e) => e.desc,
              (e) => e.date);
          break;
        case LifeIndexType.carWashing:
          collect<WeatherModelResultDailyLifeIndexCarWashing>(
              model.carWashing,
              LifeIndexType.carWashing,
              (e) => e.desc,
              (e) => e.date);
          break;
        case LifeIndexType.dressing:
          collect<WeatherModelResultDailyLifeIndexDressing>(
              model.dressing,
              LifeIndexType.dressing,
              (e) => e.desc,
              (e) => e.date);
          break;
        case LifeIndexType.comfort:
          collect<WeatherModelResultDailyLifeIndexComfort>(
              model.comfort,
              LifeIndexType.comfort,
              (e) => e.desc,
              (e) => e.date);
          break;
        case LifeIndexType.coldRisk:
          collect<WeatherModelResultDailyLifeIndexColdRisk>(
              model.coldRisk,
              LifeIndexType.coldRisk,
              (e) => e.desc,
              (e) => e.date);
          break;
        case LifeIndexType.typhoon:
          break;
      }
    }

    final width = 1.0.sw / 3;
    final height = (0.5.sh - 30) / 2;
    final ratio = width / height;
    weatherPrint("bottomSheet width: $width, height: $height, ratio: $ratio");
    return Container(
      margin: const EdgeInsets.only(top: 30),
      child: GridView.count(
        childAspectRatio: ratio,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        children: detail
            .map((e) => _buildBottomSheetIndexItem(context, e))
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final itemWidth = (1.sw - DimenConstant.mainMarginStartEnd * 2) / 3 * 5 / 4;
    return BlurRectWidget(
      child: SizedBox(
        height: itemWidth * 2,
        child: GridView.count(
          childAspectRatio: 4.0 / 5,
          physics: const NeverScrollableScrollPhysics(),
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
