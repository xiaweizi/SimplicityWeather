import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dynamic_weather/app/res/analytics_constant.dart';
import 'package:flutter_dynamic_weather/app/router.dart';
import 'package:flutter_dynamic_weather/views/common/blur_rect.dart';
import 'package:flutter_weather_bg/bg/weather_bg.dart';
import 'package:flutter_weather_bg/flutter_weather_bg.dart';
import 'package:package_info/package_info.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  WeatherType _weatherType = WeatherType.sunny;
  String _version;
  String _appName;

  Widget _buildBg(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
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
        WeatherBg(
          weatherType: _weatherType,
          width: width,
          height: height,
        )
      ],
    );
  }

  @override
  void initState() {
    getVersion();
    super.initState();
  }

  void getVersion() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        _version = packageInfo.version;
        _appName = packageInfo.appName;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            _buildBg(context),
            BlurRectWidget(
              sigmaX: 0,
              sigmaY: 0,
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQueryData.fromWindow(
                            WidgetsBinding.instance.window)
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
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(right: 9),
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                icon: Icon(
                                  Icons.more_vert,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed(WeatherRouter.example);
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
                                      const url =
                                          'https://github.com/xiaweizi/SimplicityWeather';
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
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(_appName == null ? "简悦天气" : _appName,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 30)),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text("v$_version",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white.withAlpha(200),
                                            fontSize: 16)),
                                  ]),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 20, top: 10),
                              child: Text(
                                "简约不简单，丰富不复杂",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
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
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
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
