import 'package:flutter/material.dart';
import 'package:flutter_dynamic_weather/app/res/dimen_constant.dart';
import 'package:flutter_dynamic_weather/app/utils/print_utils.dart';
import 'package:flutter_dynamic_weather/model/city_data.dart';
import 'package:flutter_dynamic_weather/net/weather_api.dart';
import 'package:flutter_dynamic_weather/views/pages/search/search_page.dart';

typedef CancelTapCallback = void Function();
typedef CancelSearchCallback = void Function(String keywords);
typedef CityItemClickCallback = void Function(CityData cityData);

class SearchAppBar extends StatefulWidget {
  final CancelTapCallback cancelTapCallback;
  final CancelSearchCallback searchTapCallback;
  final ValueChanged<String> onChanged;

  SearchAppBar(this.onChanged,
      {Key key, this.cancelTapCallback, this.searchTapCallback})
      : super(key: key);

  @override
  _SearchAppBarState createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  TextEditingController _controller = TextEditingController();
  String _buttonText = "取消";
  bool closeVisible = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 6,
          bottom: 6,
          left: DimenConstant.mainMarginStartEnd,
          right: DimenConstant.mainMarginStartEnd),
      height: kToolbarHeight,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: [
                TextField(
                    onChanged: (value) {
                      weatherPrint("value: $value");
                      widget.onChanged(value);
                      if (value != null && value.isNotEmpty) {
                        setState(() {
                          _buttonText = "搜索";
                          closeVisible = true;
                        });
                      } else {
                        _buttonText = "取消";
                        closeVisible = false;
                      }
                    },
                    controller: _controller,
                    autofocus: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                      contentPadding:
                          EdgeInsets.only(top: 1, bottom: 1, left: 12),
                      fillColor: Color(0x30cccccc),
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0x00FF0000)),
                          borderRadius: BorderRadius.all(Radius.circular(100))),
                      hintText: '搜索城市天气',
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0x00000000)),
                          borderRadius: BorderRadius.all(Radius.circular(100))),
                    )),
                Visibility(
                  visible: closeVisible,
                  child: Align(
                    alignment: Alignment(0.9, 0),
                    child: IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        _controller.text = "";
                        if (widget.onChanged != null) {
                          widget.onChanged("");
                        }
                        setState(() {
                          closeVisible = false;
                          _buttonText = "取消";
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: DimenConstant.mainMarginStartEnd,
          ),
          GestureDetector(
            child: Text(
              _buttonText,
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
            onTap: () {
              if (_controller.text == null || _controller.text.isEmpty) {
                if (widget.cancelTapCallback != null) {
                  widget.cancelTapCallback();
                }
              } else {
                if (widget.searchTapCallback != null) {
                  widget.searchTapCallback(_controller.text);
                }
              }
            },
          )
        ],
      ),
    );
  }
}
