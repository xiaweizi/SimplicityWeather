import 'package:flutter/material.dart';
import 'package:flutter_dynamic_weather/app/res/analytics_constant.dart';
import 'package:flutter_dynamic_weather/app/utils/print_utils.dart';
import 'package:flutter_dynamic_weather/views/pages/about/about_page.dart';
import 'package:flutter_dynamic_weather/views/pages/manager/manager_page.dart';
import 'package:flutter_dynamic_weather/views/pages/search/search_page.dart';
import 'package:umeng_analytics_plugin/umeng_analytics_plugin.dart';

import 'utils/router_utils.dart';

class AppAnalysis extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    if (route.settings.name != null) {
      weatherPrint("AppAnalysis didPush: ${route.settings.name}");
      UmengAnalyticsPlugin.event(AnalyticsConstant.pageShow, label: "${route.settings.name}");
      UmengAnalyticsPlugin.pageStart(route.settings.name);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    if (route.settings.name != null) {
      weatherPrint("AppAnalysis didPop: ${route.settings.name}");
      UmengAnalyticsPlugin.pageEnd(route.settings.name);
    }
  }
}

class Router {
  static const String manager = 'manager';
  static const String search = 'search';
  static const String about = 'about';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      //根据名称跳转相应页面
      case search:
        return FadeRouter(
            child: SearchPage(), settings: RouteSettings(name: search));

      case manager:
        return FadeRouter(
            child: ManagerPage(), settings: RouteSettings(name: manager));
      case about:
        return FadeRouter(
            child: AboutPage(), settings: settings);
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}
