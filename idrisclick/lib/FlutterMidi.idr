module FlutterMidi

import Dart.FFI

%inline
public export
FlutterMidi : Type
FlutterMidi = Struct "FlutterMidi,./FlutterMidi.dart" []

namespace FlutterMidi
  %inline
  public export
  new : IO FlutterMidi
  new = primIO $ prim__dart_new FlutterMidi [] (the (Parameters {tag = Void} []) [])

  %foreign "Dart:.playMidiNote"
  prim__playMidiNote : FlutterMidi -> Int -> PrimIO ()

  export
  playMidiNote : FlutterMidi -> Int -> IO ()
  playMidiNote flutterMidi midiNote = primIO $ prim__playMidiNote flutterMidi midiNote
