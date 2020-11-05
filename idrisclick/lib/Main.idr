module Main

import Flutter
import FlutterMidi

appTitle : String
appTitle = "Idris Click"

click : FlutterMidi -> IO ()
click midi = playMidiNote midi 60

appHome : FlutterMidi -> IO Stateful
appHome midi = Stateful.new [initialState @= 0, onBuild @= build]
  where
    build : StatefulWidgetState Int -> BuildContext -> IO Widget
    build state context = upcast <$> Scaffold.new [
      appBar @=> !(AppBar.new [
        title @=> !(Text.new appTitle [])
      ]),
      body @=> !(Center.new [
        child @=> !(Column.new [
          mainAxisAlignment @= MainAxisAlignment.center,
          children @= !(widgets [
            !(Text.new "You have pushed the button this many times:" []),
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

app : FlutterMidi -> IO Stateless
app midi = Stateless.new [onBuild @= build]
  where
    build : BuildContext -> IO Widget
    build _ = upcast <$> MaterialApp.new [
      title @= appTitle,
      home @=> !(appHome midi),
      theme @= !(ThemeData.new [
        primarySwatch @= Colors.blue
      ])
    ]

main : IO ()
main = do
  midi <- FlutterMidi.new
  runApp !(app midi)
