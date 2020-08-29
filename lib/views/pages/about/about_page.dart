import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dynamic_weather/app/res/weather_type.dart';
import 'package:flutter_dynamic_weather/views/bg/weather_cloud_bg.dart';
import 'package:flutter_dynamic_weather/views/bg/weather_main_bg.dart';
import 'package:flutter_dynamic_weather/views/bg/weather_rain_snow_bg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  WeatherType _weatherType = WeatherType.sunny;

  Widget _buildBg() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: WeatherUtil.getColor(_weatherType),
            stops: [0, 1],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
        ),
        WeatherCloudBg(
          weatherType: _weatherType,
        ),
        WeatherRainSnowBg(
          weatherType: _weatherType,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            _buildBg(),
            Container(
              padding: EdgeInsets.only(
                  top: MediaQueryData.fromWindow(WidgetsBinding.instance.window)
                      .padding
                      .top),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: kToolbarHeight,
                      child: Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 6),
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                          Align(
                            child: Text(
                              "关于",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 9),
                            alignment: Alignment.centerRight,
                            child: PopupMenuButton<WeatherType>(
                              icon: Icon(
                                Icons.more_vert,
                                color: Colors.white,
                                size: 20,
                              ),
                              tooltip: "长按提示",
                              initialValue: _weatherType,
                              padding: EdgeInsets.all(0.0),
                              itemBuilder: (BuildContext context) {
                                return WeatherType.values
                                    .sublist(0, WeatherType.values.length - 2)
                                    .map(
                                      (e) => PopupMenuItem<WeatherType>(
                                        child: Text(e.toString()),
                                        value: e,
                                      ),
                                    )
                                    .toList();
                              },
                              onSelected: (WeatherType action) {
                                setState(() {
                                  _weatherType = action;
                                });
                              },
                            ),
                          ),
                        ],
                      )),
                  Container(
                    height: 1.hp -
                        MediaQueryData.fromWindow(
                                WidgetsBinding.instance.window)
                            .padding
                            .top -
                        kToolbarHeight,
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 200,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 20),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/ic_launcher.png"),
                                    fit: BoxFit.cover,
                                  ),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                width: 100,
                                height: 100,
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 20),
                                child: RaisedButton(
                                  color: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(18.0),
                                    ),
                                  ),
                                  onPressed: () async {
                                    const url = 'https://github.com/xiaweizi';
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                    }
                                  },
                                  child: Text(
                                    "Github",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20, top: 20),
                            child: Text(
                              "简悦天气",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 30),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20, top: 10),
                            child: Text(
                              "简约不简单，丰富不复杂",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20, top: 20),
                            child: Text(
                              "项目简介",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 20),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20, top: 10),
                            child: Text(
                              "一款简约风格的 flutter 天气项目，提供实时、多日、24 小时、台风路径以及生活指数等服务，支持定位、删除、搜索等操作。\n\n " +
                                  "作为 flutter 实战项目，包含状态管理、网络请求、数据缓存、自定义 view、自定义动画，三方统计，事件管理等技术点，实用且丰富。",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20, top: 20),
                            child: Text(
                              "作者简介",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 20),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20, top: 10),
                            child: RichText(
                              text: TextSpan(
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                  children: <InlineSpan>[
                                    _buildPersonHome(
                                        "个人主页", "http://xiaweizi.cn/"),
                                    TextSpan(text: '\n\n'),
                                    _buildPersonHome("Github",
                                        "https://github.com/xiaweizi"),
                                    TextSpan(text: '\n\n'),
                                    _buildPersonHome("简书",
                                        "https://www.jianshu.com/u/d36586119d8c"),
                                    TextSpan(text: '\n\n'),
                                    _buildPersonHome("掘金",
                                        "https://juejin.im/user/2313028193761389"),
                                    TextSpan(text: '\n\n'),
                                    _buildPersonHome("CSDN",
                                        "https://blog.csdn.net/qq_22656383"),
                                  ]),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }

  TextSpan _buildPersonHome(String show, String url) {
    return TextSpan(
      text: show,
      style: TextStyle(
        decoration: TextDecoration.underline,
      ),
      recognizer: TapGestureRecognizer()
        ..onTap = () async {
          if (await canLaunch(url)) {
            await launch(url);
          }
        },
    );
  }
}
