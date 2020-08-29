import 'package:flutter/material.dart';
import 'package:flutter_dynamic_weather/app/res/weather_type.dart';
import 'package:flutter_dynamic_weather/app/utils/Toast.dart';
import 'package:flutter_dynamic_weather/app/utils/color_utils.dart';
import 'package:flutter_dynamic_weather/app/utils/print_utils.dart';
import 'package:flutter_dynamic_weather/app/utils/shared_preference_util.dart';
import 'package:flutter_dynamic_weather/event/change_index_envent.dart';
import 'package:flutter_dynamic_weather/model/city_data.dart';
import 'package:flutter_dynamic_weather/model/city_model_entity.dart';
import 'package:flutter_dynamic_weather/views/app/flutter_app.dart';
import 'package:flutter_dynamic_weather/views/pages/search/search_app_bar.dart';
import 'package:flutter_dynamic_weather/views/pages/search/search_page.dart';

class HotCityView extends StatefulWidget {
  final CityItemClickCallback itemClickCallback;

  HotCityView({Key key, this.itemClickCallback}) : super(key: key);

  @override
  _HotCityViewState createState() => _HotCityViewState();
}

class _HotCityViewState extends State<HotCityView> {
  List<CityData> _cityData;
  List<CityModel> cityModels;

  Widget _buildHotItem(BuildContext context, CityData cityData) {
    return Container(
      margin: EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
      child: ActionChip(
        padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        label: Text(
          "${cityData.name}",
          style: TextStyle(color: isAdd(cityData) ? Colors.blue : Colors.black),
        ),
        backgroundColor: ColorUtils.parse("#11000000"),
        onPressed: () async {
          if (isAdd(cityData)) {
            eventBus.fire(ChangeCityEvent(cityData.center));
            Navigator.of(context).pop();
          } else if (widget.itemClickCallback != null) {
            widget.itemClickCallback(cityData);
          }
        },
      ),
    );
  }

  bool isAdd(CityData cityData) {
    bool isAdd = false;
    if (cityModels != null && cityModels.isNotEmpty && cityData != null) {
      cityModels.forEach((element) {
        if (element.cityFlag == cityData.center) {
          isAdd = true;
        }
      });
    }
    return isAdd;
  }

  Widget _buildHotView() {
    if (_cityData != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 12),
            child: Text(
              "热门城市",
              style: TextStyle(color: ColorUtils.parse("#bb000000")),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Wrap(
            alignment: WrapAlignment.start,
            children: _cityData.map((e) => _buildHotItem(context, e)).toList(),
          )
        ],
      );
    } else {
      return null;
    }
  }

  Future<void> fetchHotData() async {
    _cityData = [
      CityData("北京市", "116.405285,39.904989"),
      CityData("上海市", "121.472644,31.231706"),
      CityData("广州市", "113.280637,23.125178"),
      CityData("深圳市", "114.085947,22.547"),
      CityData("珠海市", "113.553986,22.224979"),
      CityData("佛山市", "113.122717,23.028762"),
      CityData("南京市", "118.767413,32.041544"),
      CityData("苏州市", "120.619585,31.299379"),
      CityData("厦门市", "118.11022,24.490474"),
      CityData("南宁市", "108.320004,22.82402"),
      CityData("成都市", "104.065735,30.659462"),
      CityData("长沙市", "112.982279,28.19409"),
      CityData("杭州市", "120.153576,30.287459"),
      CityData("武汉市", "114.298572,30.584355"),
      CityData("青岛市", "120.355173,36.082982"),
      CityData("西安市", "125.151424,42.920415"),
      CityData("太原市", "112.549248,37.857014"),
      CityData("石家庄市", "114.502461,38.045474"),
      CityData("重庆市", "106.504962,29.533155"),
      CityData("天津市", "117.190182,39.125596"),
    ];
    cityModels = await SPUtil.getCityModels();
    setState(() {});
  }

  @override
  void initState() {
    fetchHotData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildHotView(),
    );
  }
}
