module Timer

import Dart.FFI
import Flutter

%inline
public export
Timer : Type
Timer = Struct "Timer,./Timer.dart" []

public export
IsAssignableFrom Widget Timer where

namespace Timer

  namespace New

    public export
    data Tag : Type where

    %inline
    public export
    key : Parameter Timer.New.Tag
    key = mkParameter "key" Key

    %inline
    public export
    onBuild : Parameter Timer.New.Tag
    onBuild = mkParameter "onBuild" (Double -> BuildContext -> IO Widget)

    %inline
    public export
    NamedParameters : Type
    NamedParameters = Parameters [
      Timer.New.key,
      Timer.New.onBuild
    ]

  %inline
  public export
  new : Timer.New.NamedParameters -> IO Timer
  new ps = primIO (prim__dart_new Timer [] ps)
