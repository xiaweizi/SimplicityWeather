import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dynamic_weather/event/change_index_envent.dart';
import 'package:flutter_dynamic_weather/views/app/flutter_app.dart';
import 'package:flutter_dynamic_weather/views/pages/home/speak_anim.dart';

class RealTimeTempView extends StatefulWidget {
  final String temp;
  final String content;

  RealTimeTempView({Key key, this.temp, this.content}) : super(key: key);

  @override
  _RealTimeTempViewState createState() => _RealTimeTempViewState();
}

enum TtsState { playing, stopped, paused, continued }

class _RealTimeTempViewState extends State<RealTimeTempView> {
  TtsState ttsState = TtsState.stopped;
  StreamSubscription _subscription;

  @override
  void initState() {
    _subscription = eventBus.on<TtsStatusEvent>().listen((event) {
      setState(() {
        ttsState = event.ttsState;
      });
    });
    super.initState();
  }

  void updateStatus(TtsState status) {
    setState(() => ttsState = status);
    eventBus.fire(TtsStatusEvent(status));
  }


  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var color = Colors.white;
    return GestureDetector(
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 10,
            ),
            Text(
              "${widget.temp}",
              style: TextStyle(
                  fontSize: 150, fontWeight: FontWeight.w400, color: color),
            ),
            Text(
              "°",
              style: TextStyle(
                  fontSize: 50, fontWeight: FontWeight.w500, color: color),
            ),
            Container(
              alignment: Alignment(1, 0.9),
              width: 30,
              height: 150,
              child: AnimatedCrossFade(
                firstChild: Image.asset(
                  "assets/images/play.png",
                  color: color,
                ),
                secondChild: SpeakAnim(),
                crossFadeState: ttsState == TtsState.playing
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: Duration(milliseconds: 150),
              ),
            ),
          ],
        ),
      ),
      onTap: () {

      },
    );
  }
}
