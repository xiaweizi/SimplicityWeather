import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dynamic_weather/app/utils/print_utils.dart';
import 'package:flutter_dynamic_weather/event/change_index_envent.dart';
import 'package:flutter_dynamic_weather/views/app/flutter_app.dart';
import 'package:flutter_tts/flutter_tts.dart';

class RealTimeTempView extends StatefulWidget {
  final String temp;
  final String content;

  RealTimeTempView({Key key, this.temp, this.content}) : super(key: key);

  @override
  _RealTimeTempViewState createState() => _RealTimeTempViewState();
}

enum TtsState { playing, stopped, paused, continued }

class _RealTimeTempViewState extends State<RealTimeTempView> {
  FlutterTts _flutterTts;
  TtsState ttsState = TtsState.stopped;
  StreamSubscription _subscription;

  @override
  void initState() {
    initTts();
    _subscription = eventBus.on<TtsStatusEvent>().listen((event) {
      setState(() {
        ttsState = event.ttsState;
      });
    });
    super.initState();
  }

  initTts() {
    _flutterTts = FlutterTts();
    _flutterTts.setLanguage("zh");
    if (!kIsWeb) {
      if (Platform.isAndroid) {
        _getEngines();
      }
    }
    _flutterTts.setStartHandler(() {
      weatherPrint("Playing");
      updateStatus(TtsState.playing);
    });
    _flutterTts.setCompletionHandler(() {
      weatherPrint("Complete");
      updateStatus(TtsState.stopped);
    });
    _flutterTts.setCancelHandler(() {
      weatherPrint("Cancel");
      updateStatus(TtsState.stopped);
    });
    if (kIsWeb || Platform.isIOS) {
      _flutterTts.setPauseHandler(() {
        weatherPrint("Paused");
        updateStatus(TtsState.paused);
      });
      _flutterTts.setErrorHandler((msg) {
        weatherPrint("error: $msg");
        updateStatus(TtsState.stopped);
      });
    }
  }

  Future _getEngines() async {
    var engines = await _flutterTts.getEngines;
    if (engines != null) {
      for (dynamic engine in engines) {
        weatherPrint(engine);
      }
    }
  }

  void updateStatus(TtsState status) {
    setState(() => ttsState = status);
    eventBus.fire(TtsStatusEvent(status));
  }

  Future _speak() async {
    if (widget.content != null) {
      if (widget.content.isNotEmpty) {
        weatherPrint("content: ${widget.content}");
        var result = await _flutterTts.speak(widget.content);
        if (result == 1) updateStatus(TtsState.playing);
      }
    }
  }

  Future _stop() async {
    var result = await _flutterTts.stop();
    if (result == 1) updateStatus(TtsState.stopped);
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  fontSize: 150,
                  fontWeight: FontWeight.w400,
                  color: Colors.white),
            ),
            Text(
              "°",
              style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
            Container(
              alignment: Alignment(1, 0.8),
              width: 20,
              height: 150,
              child: Icon(
                Icons.ac_unit,
                color: Colors.white,
              ),
            ),
            Text("$ttsState"),
          ],
        ),
      ),
      onTap: () {
        if (ttsState != TtsState.playing) {
          _speak();
        } else {
          _stop();
        }
      },
    );
  }
}
