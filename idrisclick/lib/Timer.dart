import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class Timer extends StatefulWidget {
  final Widget Function(double, BuildContext) onBuild;

  Timer({Key key, this.onBuild}) : super(key: key);

  @override
  _TimerState createState() => _TimerState(this.onBuild);
}

class _TimerState extends State<Timer> with SingleTickerProviderStateMixin {
  final Widget Function(double, BuildContext) onBuild;

  Ticker ticker;

  Duration _elapsed = Duration.zero;

  _TimerState(this.onBuild) : super();

  @override
  void initState() {
    ticker = createTicker((elapsed) {
      setState(() {
        _elapsed = elapsed;
      });
    })
      ..start();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return onBuild(_elapsed.inMilliseconds.toDouble(), context);
  }
}
