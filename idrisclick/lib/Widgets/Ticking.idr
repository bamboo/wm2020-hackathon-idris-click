module Widgets.Ticking

import public Dart.Core
import Dart.FFI
import Flutter

%inline
public export
Ticking : Type
Ticking = Struct "Ticking,./Widgets/Ticking.dart" []

public export
IsAssignableFrom Widget Ticking where

%inline
public export
TickingWidgetState : Type -> Type
TickingWidgetState ty = Struct "TickingWidgetState,./Widgets/Ticking.dart" [("value", ty)]

namespace TickingWidgetState
  %inline
  public export
  get : TickingWidgetState ty -> ty
  get widgetState = widgetState `getField` "value"

namespace Ticking

  namespace New
    public export
    data Tag : (stateType : Type) -> Type where

    %inline
    public export
    key : {stateType : Type} -> Parameter (Ticking.New.Tag stateType)
    key = mkParameter "key" Key

    %inline
    public export
    initialState : {stateType : Type} -> Parameter (Ticking.New.Tag stateType)
    initialState = mkParameter "initialState" stateType

    %inline
    public export
    onTick : {stateType : Type} -> Parameter (Ticking.New.Tag stateType)
    onTick = mkParameter "onTick" (Duration -> stateType -> IO (Maybe stateType))

    %inline
    public export
    onBuild : {stateType : Type} -> Parameter (Ticking.New.Tag stateType)
    onBuild = mkParameter "onBuild" (TickingWidgetState stateType -> BuildContext -> IO Widget)

    %inline
    public export
    NamedParameters : {stateType : Type} -> Type
    NamedParameters = Parameters [
      Ticking.New.key {stateType = stateType},
      Ticking.New.initialState {stateType = stateType},
      Ticking.New.onTick {stateType = stateType},
      Ticking.New.onBuild {stateType = stateType}
    ]

  %inline
  public export
  new : {stateType : Type} -> Ticking.New.NamedParameters {stateType = stateType} -> IO Ticking
  new ps = primIO (prim__dart_new Ticking [] ps)

  %foreign "Dart:.modify"
  prim__modify : TickingWidgetState stateType -> (stateType -> stateType) -> PrimIO ()

  export
  modify : TickingWidgetState stateType -> (stateType -> stateType) -> IO ()
  modify state f = primIO (prim__modify state f)