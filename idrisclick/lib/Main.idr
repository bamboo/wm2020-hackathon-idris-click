module Main

import Flutter

appTitle : String
appTitle = "Idris Click"

appHome : IO Stateful
appHome = Stateful.new [initialState @= 0, onBuild @= build]
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
        onPressed @= modify state (+ 1)
      ])
    ]

app : IO Stateless
app = Stateless.new [onBuild @= build]
  where
    build : BuildContext -> IO Widget
    build _ = upcast <$> MaterialApp.new [
      title @= appTitle,
      home @=> !appHome,
      theme @= !(ThemeData.new [
        primarySwatch @= Colors.blue
      ])
    ]

main : IO ()
main = runApp !app
