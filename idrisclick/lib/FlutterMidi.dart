import 'package:flutter_midi/flutter_midi.dart' as flutter_midi;
import 'package:flutter/services.dart';

class FlutterMidi {
  final flutter_midi.FlutterMidi _midi = flutter_midi.FlutterMidi();

  FlutterMidi() {
    rootBundle
        .load("assets/weedsgm3.sf2")
        .then((bytes) => _midi.prepare(sf2: bytes, name: "weedsgm3.sf2"));
  }

  void playMidiNote(int midiNote) {
    _midi.playMidiNote(midi: midiNote);
  }
}
