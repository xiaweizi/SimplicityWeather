import 'package:flutter/material.dart';
import 'package:flutter_weather_bg/flutter_weather_bg.dart';
import 'package:flutter_weather_bg/utils/print_utils.dart';

/// 普通的 ViewPager 展示样式
class PageViewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: PageView.builder(
          physics: BouncingScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            weatherPrint("pageView: ${MediaQuery.of(context).size}");
            return Stack(
              children: [
                WeatherBg(
                  weatherType: WeatherType.values[index],
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
                Center(
                  child: Text(
                    WeatherUtil.getWeatherDesc(WeatherType.values[index]),
                    style: TextStyle(
                        color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            );
          },
          itemCount: WeatherType.values.length,
        ),
      ),
    );
  }
}

