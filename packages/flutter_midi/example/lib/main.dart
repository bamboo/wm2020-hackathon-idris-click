import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_midi/flutter_midi.dart';

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

// import 'web_midi.dart';

// The existing imports
// !! Keep your existing impots here !!

/// main is entry point of Flutter application
void main() {
  // Desktop platforms aren't a valid platform.
  if (!kIsWeb) _setTargetPlatformForDesktop();
  return runApp(MyApp());
}

/// If the current platform is desktop, override the default platform to
/// a supported platform (iOS for macOS, Android for Linux and Windows).
/// Otherwise, do nothing.
void _setTargetPlatformForDesktop() {
  TargetPlatform targetPlatform;
  if (Platform.isMacOS) {
    targetPlatform = TargetPlatform.iOS;
  } else if (Platform.isLinux || Platform.isWindows) {
    targetPlatform = TargetPlatform.android;
  }
  if (targetPlatform != null) {
    debugDefaultTargetPlatformOverride = targetPlatform;
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _flutterMidi = FlutterMidi();
  @override
  void initState() {
    if (!kIsWeb) {
      load(_value);
    } else {
      _flutterMidi.prepare(sf2: null);
    }
    super.initState();
  }

  void load(String asset) async {
    print("Loading File...");
    _flutterMidi.unmute();
    ByteData _byte = await rootBundle.load(asset);
    //assets/sf2/SmallTimGM6mb.sf2
    //assets/sf2/Piano.SF2
    _flutterMidi.prepare(sf2: _byte, name: _value.replaceAll("assets/", ""));
  }

  String _value = "assets/Piano.sf2";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // DropdownButton<String>(
            //   value: _value,
            //   items: [
            //     DropdownMenuItem(
            //       child: Text("Soft Piano"),
            //       value: "assets/sf2/SmallTimGM6mb.sf2",
            //     ),
            //     DropdownMenuItem(
            //       child: Text("Loud Piano"),
            //       value: "assets/sf2/Piano.SF2",
            //     ),
            //   ],
            //   onChanged: (String value) {
            //     setState(() {
            //       _value = value;
            //     });
            //     load(_value);
            //   },
            // ),
            RaisedButton(
              child: Text("Play C"),
              onPressed: () {
                _play(60);
              },
            ),
          ],
        )),
      ),
    );
  }

  void _play(int midi) {
    if (kIsWeb) {
      // WebMidi.play(midi);
    } else {
      _flutterMidi.playMidiNote(midi: midi);
    }
  }
}
