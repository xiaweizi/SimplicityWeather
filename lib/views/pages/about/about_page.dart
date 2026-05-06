import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dynamic_weather/app/router.dart';
import 'package:flutter_dynamic_weather/views/common/blur_rect.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_weather_bg/flutter_weather_bg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final WeatherType _weatherType = WeatherType.sunny;
  String? _version;
  String? _appName;

  Widget _buildBg(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: WeatherUtil.getColor(_weatherType),
              stops: const [0, 1],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        WeatherBg(
          weatherType: _weatherType,
          width: width,
          height: height,
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (!mounted) return;
    setState(() {
      _version = info.version;
      _appName = info.appName;
    });
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          _buildBg(context),
          BlurRectWidget(
            sigmaX: 0,
            sigmaY: 0,
            child: Container(
              padding: EdgeInsets.only(top: topPad),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: kToolbarHeight,
                    child: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 6),
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                        const Align(
                          child: Text(
                            "关于",
                            style:
                                TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(right: 9),
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: const Icon(
                              Icons.more_vert,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () => Navigator.of(context)
                                .pushNamed(WeatherRouter.example),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 1.sh - topPad - kToolbarHeight,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 200),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 20),
                                decoration: BoxDecoration(
                                  image: const DecorationImage(
                                    image: AssetImage(
                                        "assets/images/ic_launcher.png"),
                                    fit: BoxFit.cover,
                                  ),
                                  border: Border.all(
                                      color: Colors.white, width: 2),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                width: 100,
                                height: 100,
                              ),
                              Container(
                                margin: const EdgeInsets.only(right: 20),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(18.0)),
                                    ),
                                  ),
                                  onPressed: () => _openUrl(
                                      'https://github.com/xiaweizi/SimplicityWeather'),
                                  child: const Text(
                                    "Github",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 20, top: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  _appName ?? "简悦天气",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 30),
                                ),
                                const SizedBox(width: 20),
                                Text(
                                  "v${_version ?? ''}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white.withAlpha(200),
                                      fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 20, top: 10),
                            child: const Text(
                              "简约不简单，丰富不复杂",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 20, top: 20),
                            child: const Text(
                              "项目简介",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 20),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 20, top: 10),
                            child: const Text(
                              "一款简约风格的 flutter 天气项目，提供实时、多日、24 小时、台风路径以及生活指数等服务，支持定位、删除、搜索等操作。\n\n"
                              "作为 flutter 实战项目，包含状态管理、网络请求、数据缓存、自定义 view、自定义动画，事件管理等技术点，实用且丰富。",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 20, top: 20),
                            child: const Text(
                              "作者简介",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 20),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 20, top: 10),
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                                children: <InlineSpan>[
                                  _buildPersonHome(
                                      "个人主页", "http://xiaweizi.cn/"),
                                  const TextSpan(text: '\n\n'),
                                  _buildPersonHome("Github",
                                      "https://github.com/xiaweizi"),
                                  const TextSpan(text: '\n\n'),
                                  _buildPersonHome("简书",
                                      "https://www.jianshu.com/u/d36586119d8c"),
                                  const TextSpan(text: '\n\n'),
                                  _buildPersonHome("掘金",
                                      "https://juejin.im/user/2313028193761389"),
                                  const TextSpan(text: '\n\n'),
                                  _buildPersonHome("CSDN",
                                      "https://blog.csdn.net/qq_22656383"),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextSpan _buildPersonHome(String show, String url) {
    return TextSpan(
      text: show,
      style: const TextStyle(decoration: TextDecoration.underline),
      recognizer: TapGestureRecognizer()..onTap = () => _openUrl(url),
    );
  }
}
