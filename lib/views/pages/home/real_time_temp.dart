import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dynamic_weather/app/utils/print_utils.dart';
import 'package:flutter_dynamic_weather/event/change_index_envent.dart';
import 'package:flutter_dynamic_weather/views/app/flutter_app.dart';
import 'package:flutter_dynamic_weather/views/pages/home/speak_anim.dart';
import 'package:flutter_tts/flutter_tts.dart';

class RealTimeTempView extends StatefulWidget {
  final String? temp;
  final String? content;

  const RealTimeTempView({super.key, this.temp, this.content});

  @override
  State<RealTimeTempView> createState() => _RealTimeTempViewState();
}

enum TtsState { playing, stopped, paused, continued }

class _RealTimeTempViewState extends State<RealTimeTempView> {
  late FlutterTts _flutterTts;
  TtsState ttsState = TtsState.stopped;
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    initTts();
    _subscription = eventBus.on<TtsStatusEvent>().listen((event) {
      if (!mounted) return;
      setState(() {
        ttsState = event.ttsState;
      });
    });
  }

  void initTts() {
    _flutterTts = FlutterTts();
    _flutterTts.setLanguage("zh");
    if (!kIsWeb && Platform.isAndroid) {
      _getEngines();
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

  Future<void> _getEngines() async {
    final engines = await _flutterTts.getEngines;
    if (engines is List) {
      for (final engine in engines) {
        weatherPrint("$engine");
      }
    }
  }

  void updateStatus(TtsState status) {
    if (mounted) setState(() => ttsState = status);
    eventBus.fire(TtsStatusEvent(status));
  }

  Future<void> _speak() async {
    final content = widget.content;
    if (content != null && content.isNotEmpty) {
      weatherPrint("content: $content");
      final result = await _flutterTts.speak(content);
      if (result == 1) updateStatus(TtsState.playing);
    }
  }

  Future<void> _stop() async {
    final result = await _flutterTts.stop();
    if (result == 1) updateStatus(TtsState.stopped);
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const color = Colors.white;
    return GestureDetector(
      onTap: () {
        if (ttsState != TtsState.playing) {
          _speak();
        } else {
          _stop();
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 10),
          Text(
            "${widget.temp ?? ''}",
            style: const TextStyle(
                fontSize: 150, fontWeight: FontWeight.w400, color: color),
          ),
          const Text(
            "°",
            style: TextStyle(
                fontSize: 50, fontWeight: FontWeight.w500, color: color),
          ),
          Container(
            alignment: const Alignment(1, 0.9),
            width: 30,
            height: 150,
            child: AnimatedCrossFade(
              firstChild: Image.asset("assets/images/play.png", color: color),
              secondChild: const SpeakAnim(),
              crossFadeState: ttsState == TtsState.playing
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 150),
            ),
          ),
        ],
      ),
    );
  }
}
