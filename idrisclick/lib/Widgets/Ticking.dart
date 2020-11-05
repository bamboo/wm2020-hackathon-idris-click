import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class Ticking extends StatefulWidget {
  final Object Function(Duration, Object) onTick;
  final Widget Function(TickingWidgetState, BuildContext) onBuild;
  final Object initialState;

  Ticking({
    Key key,
    @required this.onTick,
    @required this.onBuild,
    @required this.initialState,
  }) : super(key: key);

  @override
  _TickingState createState() => _TickingState(
        this.initialState,
        this.onTick,
        this.onBuild,
      );
}

class _TickingState extends State<Ticking> with SingleTickerProviderStateMixin {
  final Object Function(Duration, Object) onTick;
  final Widget Function(TickingWidgetState, BuildContext) onBuild;
  Object _state;

  Ticker ticker;

  _TickingState(this._state, this.onTick, this.onBuild) : super();

  @override
  void initState() {
    ticker = createTicker((elapsed) {
      final newState = onTick(elapsed, _state);
      switch ((newState as List)[0] as int) {
        case 1:
          {
            setState(() {
              _state = newState;
            });
            break;
          }
        default:
      }
    })
      ..start();
    super.initState();
  }

  void modify(Object Function(Object) f) {
    setState(() {
      _state = f(_state);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return onBuild(TickingWidgetState(_state, this), context);
  }
}

class TickingWidgetState {
  final dynamic value;
  final _TickingState _state;
  TickingWidgetState(this.value, this._state);
  void modify(Object Function(Object) f) {
    _state.modify(f);
  }
}
