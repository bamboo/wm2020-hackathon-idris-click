module Main

import Flutter
import FlutterMidi
import Timer

appTitle : String
appTitle = "Idris Click"

click : FlutterMidi -> IO ()
click midi = playMidiNote midi 60

appHome : FlutterMidi -> IO Timer
appHome midi = Timer.new [onBuild @= build]
  where
    build : Double -> BuildContext -> IO Widget
    build state context = upcast <$> Scaffold.new [
      appBar @=> !(AppBar.new [
        title @=> !(Text.new appTitle [])
      ]),
      body @=> !(Center.new [
        child @=> !(Column.new [
          mainAxisAlignment @= MainAxisAlignment.center,
          children @= !(widgets [
            !(Text.new "You have pushed the button this many times:" []),
            !(Text.new (show (state)) [
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
