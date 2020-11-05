module Main

import Flutter
import FlutterMidi
import Widgets.Ticking
import Performance

inMilliseconds : Duration -> Int
inMilliseconds = (`getField` "inMilliseconds")

data ClickState
  = Idle
  | Starting
  | Playing Click

Show ClickState where
  show Idle = "idle"
  show Starting = "starting"
  show (Playing _) = "playing"

record AppState where
  constructor MkAppState
  bpm : Bpm
  clickState : ClickState

defaultAppState : AppState
defaultAppState = MkAppState 100 Idle

appTitle : String
appTitle = "Idris Click"

moreCowbell : FlutterMidi -> IO ()
moreCowbell midi = writeMidiEvent midi 0x90 9 56 127 -- Cowbell

appHome : FlutterMidi -> IO Ticking
appHome midi = Ticking.new [onTick @= tick, onBuild @= build, initialState @= defaultAppState]
  where
    onPlay : AppState -> AppState
    onPlay app = case app.clickState of
      Idle => record { clickState = Starting } app
      _ => record { clickState = Idle } app

    tick : Duration -> AppState -> IO (Maybe AppState)
    tick elapsed app = case app.clickState of
      Idle => pure Nothing
      Starting => do
        let clickState' = Playing (startPerformance app.bpm (inMilliseconds elapsed))
        pure (Just (record { clickState = clickState' } app))
      Playing click =>
        case (step (inMilliseconds elapsed) click) of
          Just click' => do
            moreCowbell midi
            pure (Just (record { clickState = Playing click'} app))
          _ => pure Nothing

    build : TickingWidgetState AppState -> BuildContext -> IO Widget
    build state context = upcast <$> Scaffold.new [
      appBar @=> !(AppBar.new [
        title @=> !(Text.new appTitle [])
      ]),
      body @=> !(Center.new [
        child @=> !(Column.new [
          mainAxisAlignment @= MainAxisAlignment.center,
          children @= !(widgets [
            !(Text.new (show (get state).bpm) [
              style @= headline4 (textTheme !(Theme.of_ context))
            ]),
            !(Slider.new [
              value @= cast (get state).bpm,
              min @= 20,
              max @= 240,
              onChanged @= \bpm' => modify state (record { bpm = cast bpm' })
            ])
          ])
        ])
      ]),
      floatingActionButton @=> !(FloatingActionButton.new [
        tooltip @= "Increment",
        child @=> !(Icon.new Icons.play_arrow []),
        onPressed @= modify state onPlay
      ])
    ]

app : IO Stateless
app = Stateless.new [onBuild @= build]
  where
    build : BuildContext -> IO Widget
    build _ = do
      midi <- FlutterMidi.new
      upcast <$> MaterialApp.new [
        title @= appTitle,
        home @=> !(appHome midi),
        theme @= !(ThemeData.new [
          primarySwatch @= Colors.blue
        ])
      ]

main : IO ()
main = runApp !app
