import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dynamic_weather/app/router.dart';
import 'package:flutter_dynamic_weather/app/utils/print_utils.dart';
import 'package:flutter_dynamic_weather/event/change_index_envent.dart';
import 'package:flutter_dynamic_weather/model/city_model_entity.dart';
import 'package:flutter_dynamic_weather/views/app/flutter_app.dart';

class MainAppBar extends StatefulWidget {
  final List<CityModel>? cityModels;

  const MainAppBar({super.key, this.cityModels});

  @override
  State<MainAppBar> createState() => _MainAppBarState();
}

class _MainAppBarState extends State<MainAppBar> {
  int _index = 0;
  StreamSubscription? _subscription;

  Widget _buildAppBarTitle() {
    final models = widget.cityModels;
    if (models == null || models.isEmpty) return const SizedBox.shrink();
    if (_index >= models.length) _index = models.length - 1;
    if (_index < 0) return const SizedBox.shrink();
    final cityModel = models[_index];
    return Text(
      "${cityModel.displayedName ?? ''}",
      style: const TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
    );
  }

  bool isLocated(CityModel cityModel) {
    final models = widget.cityModels;
    if (models == null || models.isEmpty) return false;
    for (final element in models) {
      if (element.isLocated == true && cityModel == element) return true;
    }
    return false;
  }

  Widget _buildPointWidget() {
    final models = widget.cityModels;
    if (models == null || models.length <= 1) return const SizedBox.shrink();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: models
          .map((e) => Container(
                margin: const EdgeInsets.only(left: 3, top: 3),
                child: Icon(
                  isLocated(e) ? Icons.location_on : Icons.brightness_1,
                  size: isLocated(e) ? 10 : 5,
                  color: models.indexOf(e) == _index
                      ? Colors.white
                      : Colors.white54,
                ),
              ))
          .toList(),
    );
  }

  @override
  void initState() {
    super.initState();
    _subscription = eventBus.on<ChangeMainAppBarIndexEvent>().listen((event) {
      weatherPrint("收到 event ${event.index}");
      if (!mounted) return;
      setState(() {
        _index = event.index;
      });
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kToolbarHeight,
      child: Row(
        children: [
          IconButton(
            padding: const EdgeInsets.only(left: 20),
            onPressed: () {
              final models = widget.cityModels;
              if (models == null || models.isEmpty) {
                Navigator.of(context).pushNamed(WeatherRouter.search);
              } else {
                Navigator.of(context).pushNamed(WeatherRouter.manager);
              }
            },
            icon: const Icon(Icons.add, color: Colors.white),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildAppBarTitle(),
                _buildPointWidget(),
              ],
            ),
          ),
          IconButton(
            padding: const EdgeInsets.only(right: 20),
            onPressed: () =>
                Navigator.of(context).pushNamed(WeatherRouter.about),
            icon: const Icon(Icons.more_vert, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }
}
