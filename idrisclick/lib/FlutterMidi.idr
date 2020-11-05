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

  %foreign "Dart:.writeMidiEvent"
  prim__writeMidiEvent : FlutterMidi -> Int -> Int -> Int -> Int -> PrimIO ()

  export
  writeMidiEvent : FlutterMidi -> (command : Int) -> (channel : Int) -> (note : Int) -> (velocity : Int) -> IO ()
  writeMidiEvent flutterMidi command channel note velocity = primIO $ prim__writeMidiEvent flutterMidi command channel note velocity

