import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dynamic_weather/app/router.dart';
import 'package:flutter_dynamic_weather/app/utils/print_utils.dart';
import 'package:flutter_dynamic_weather/event/change_index_envent.dart';
import 'package:flutter_dynamic_weather/model/city_model_entity.dart';
import 'package:flutter_dynamic_weather/views/app/flutter_app.dart';


class MainAppBar extends StatefulWidget {
  final List<CityModel> cityModels;

  MainAppBar({Key key, this.cityModels}) : super(key: key);

  @override
  _MainAppBarState createState() => _MainAppBarState();
}

class _MainAppBarState extends State<MainAppBar> {
  int _index = 0;
  StreamSubscription _subscription;

  Widget _buildAppBarTitle() {
    if (widget.cityModels == null || widget.cityModels.isEmpty) {
      return Container();
    }
    if (_index >= widget.cityModels.length) {
      _index = widget.cityModels.length - 1;
    }
    int index = _index;
    if (index >= widget.cityModels.length) {
      index = _index - 1;
    }
    if (index >= widget.cityModels.length) {
      return Container();
    }
    CityModel cityModel = widget.cityModels[index];
    return Text(
      "${cityModel.displayedName}",
      style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
    );
  }

  bool isLocated(CityModel cityModel) {
    bool isLocated = false;
    if (widget.cityModels != null && widget.cityModels.isNotEmpty) {
      widget.cityModels.forEach((element) {
        if (element.isLocated == true && cityModel == element) {
          isLocated = true;
        }
      });
    }
    return isLocated;
  }

  Widget _buildPointWidget() {
    if (widget.cityModels != null && widget.cityModels.length > 1) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: widget.cityModels
            .map((e) => Container(
                  margin: EdgeInsets.only(left: 3, top: 3),
                  child: Icon(
                    isLocated(e) ? Icons.location_on : Icons.brightness_1,
                    size: isLocated(e) ? 10 : 5,
                    color: widget.cityModels.indexOf(e) == _index
                        ? Colors.white
                        : Colors.white54,
                  ),
                ))
            .toList(),
      );
    }
    return Container();
  }

  @override
  void initState() {
    _subscription = eventBus.on<ChangeMainAppBarIndexEvent>().listen((event) {
      weatherPrint("收到 event ${event.index}");
      setState(() {
        _index = event.index;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight,
      child: Row(
        children: [
          IconButton(
            padding: EdgeInsets.only(left: 20),
            onPressed: () async {
              Navigator.of(context).pushNamed(Router.manager);
            },
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildAppBarTitle(),
                  _buildPointWidget(),
                ],
              ),
            ),
          ),
          IconButton(
            padding: EdgeInsets.only(right: 20),
            onPressed: () {
              Navigator.of(context).pushNamed(Router.about);
            },
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
              size: 20,
            ),
          )
        ],
      ),
    );
  }
}
