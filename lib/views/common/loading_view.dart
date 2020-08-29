import 'package:flutter/material.dart';

enum ViewState { loading, error, empty }

class StateView extends StatelessWidget {
  final ViewState weatherState;
  final bool isDark;

  StateView(
      {Key key, this.weatherState = ViewState.loading, this.isDark = false})
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
        color: isDark == true ? Color(0xffffffff) : Color(0xff000000),
        width: 60,
        height: 60,
      );
    } else if (weatherState == ViewState.error) {
      return Image.asset(
        "assets/images/error.png",
        color: isDark == true ? Color(0xffffffff) : Color(0xff000000),
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
          child: new Container(
            decoration: ShapeDecoration(
              color: isDark == true ? Color(0xff000000) : Color(0xffffffff),
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
                        color: isDark == true
                            ? Color(0xffffffff)
                            : Color(0xff000000)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
