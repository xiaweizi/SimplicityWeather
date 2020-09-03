import 'package:flutter/material.dart';
import 'package:flutter_dynamic_weather/views/common/blur_rect.dart';

enum ViewState { loading, error, empty }

class StateView extends StatelessWidget {
  final ViewState weatherState;

  StateView(
      {Key key, this.weatherState = ViewState.loading})
      : super(key: key);

  String _getDesc() {
    if (weatherState == ViewState.empty) {
      return "暂无数据";
    } else if (weatherState == ViewState.error) {
      return "请求失败";
    } else {
      return "正在加载中";
    }
  }

  Widget _getWidget() {
    if (weatherState == ViewState.empty) {
      return Image.asset(
        "assets/images/empty.png",
        color: Color(0xffffffff),
        width: 60,
        height: 60,
      );
    } else if (weatherState == ViewState.error) {
      return Image.asset(
        "assets/images/error.png",
        color: Color(0xffffffff),
        width: 60,
        height: 60,
      );
    } else {
      return CircularProgressIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      type: MaterialType.transparency,
      child: new Center(
        child: new SizedBox(
          width: 120.0,
          height: 120.0,
          child: BlurRectWidget(
            color: Colors.black.withAlpha(100),
            child: new Container(
              width: 120.0,
              height: 120.0,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
              ),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _getWidget(),
                  new Padding(
                    padding: const EdgeInsets.only(
                      top: 20.0,
                    ),
                    child: new Text(
                      _getDesc(),
                      style: TextStyle(
                          color: Color(0xffffffff),
                    ),
                  ),
                  )],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
