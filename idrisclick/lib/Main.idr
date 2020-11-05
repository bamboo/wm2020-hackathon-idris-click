module Main

import Flutter
import FlutterMidi
import Widgets.Ticking
import Performance

inMilliseconds : Duration -> Int
inMilliseconds = (`getField` "inMilliseconds")

data State
  = Idle
  | Starting
  | Playing Click

Show State where
  show Idle = "idle"
  show Starting = "starting"
  show (Playing _) = "playing"

appTitle : String
appTitle = "Idris Click"

moreCowbell : FlutterMidi -> IO ()
moreCowbell midi = writeMidiEvent midi 0x90 9 56 127 -- Cowbell

appHome : FlutterMidi -> IO Ticking
appHome midi = Ticking.new [onTick @= tick, onBuild @= build, initialState @= Idle]
  where
    onPlay : State -> State
    onPlay Idle = Starting
    onPlay _ = Idle

    tick : Duration -> State -> IO (Maybe State)
    tick elapsed Idle = pure Nothing
    tick elapsed Starting =
      pure (Just (Playing (startPerformance 60 (inMilliseconds elapsed))))
    tick elapsed (Playing click) =
      case (step (inMilliseconds elapsed) click) of
        Just click' => do
          moreCowbell midi
          pure (Just (Playing click'))
        _ => pure Nothing

    build : TickingWidgetState State -> BuildContext -> IO Widget
    build state context = upcast <$> Scaffold.new [
      appBar @=> !(AppBar.new [
        title @=> !(Text.new appTitle [])
      ]),
      body @=> !(Center.new [
        child @=> !(Column.new [
          mainAxisAlignment @= MainAxisAlignment.center,
          children @= !(widgets [
            !(Text.new (show (get state)) [
              style @= headline4 (textTheme !(Theme.of_ context))
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
