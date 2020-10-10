import 'package:flutter/material.dart';
import 'package:flutter_dynamic_weather/app/res/analytics_constant.dart';
import 'package:flutter_dynamic_weather/app/utils/print_utils.dart';
import 'package:flutter_dynamic_weather/example/anim_view.dart';
import 'package:flutter_dynamic_weather/example/grid_view.dart';
import 'package:flutter_dynamic_weather/example/list_view.dart';
import 'package:flutter_dynamic_weather/example/main.dart';
import 'package:flutter_dynamic_weather/example/page_view.dart';
import 'package:flutter_dynamic_weather/views/pages/about/about_page.dart';
import 'package:flutter_dynamic_weather/views/pages/manager/manager_page.dart';
import 'package:flutter_dynamic_weather/views/pages/search/search_page.dart';

import 'utils/router_utils.dart';

class AppAnalysis extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    if (route.settings.name != null) {
      weatherPrint("AppAnalysis didPush: ${route.settings.name}");
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    if (route.settings.name != null) {
      weatherPrint("AppAnalysis didPop: ${route.settings.name}");
    }
  }
}

class WeatherRouter {
  static const String manager = 'manager';
  static const String search = 'search';
  static const String about = 'about';
  static const String example = 'example';

  static const String routePage = "page";
  static const String routeList = "list";
  static const String routeGrid = "grid";
  static const String routeAnim = "anim";

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
        return FadeRouter(child: AboutPage(), settings: settings);
      case example:
        return FadeRouter(child: MyExampleApp(), settings: settings);
      case routePage:
        return FadeRouter(child: PageViewWidget(), settings: settings);
      case routeList:
        return FadeRouter(child: ListViewWidget(), settings: settings);
      case routeGrid:
        return FadeRouter(child: GridViewWidget(), settings: settings);
      case routeAnim:
        return FadeRouter(child: AnimViewWidget(), settings: settings);
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
