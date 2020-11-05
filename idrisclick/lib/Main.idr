module Main

import Flutter
import FlutterMidi
import Widgets.Ticking

data State = Idle

Show State where
  show Idle = "idle"

appTitle : String
appTitle = "Idris Click"

click : FlutterMidi -> IO ()
click midi = writeMidiEvent midi 0x90 9 56 127 -- Cowbell

appHome : FlutterMidi -> IO Ticking
appHome midi = Ticking.new [onTick @= tick, onBuild @= build, initialState @= Idle]
  where
    tick : Duration -> State -> IO (Maybe State)
    tick elapsed state = pure Nothing

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
        onPressed @= click midi
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
