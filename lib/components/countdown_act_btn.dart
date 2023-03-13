import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer_app/controller/controllers.dart';

class CountDownActBtn extends StatelessWidget {
  final MarkTimerStream _markTimer = MarkTimerStream();

  @override
  Widget build(BuildContext context) {
    final countDown = context.watch<CountDownStream>();
    final markTimerClosed =
        context.select<MarkTimerStream, ValueNotifier<bool>>(
            (value) => value.isClosed);
    final themeClosed =
        context.select<ThemeMenuNotifier, bool>((value) => value.isClosed);

    final theme = Theme.of(context);
    final btnStyle = theme.elevatedButtonTheme.style;
    final selectedBtnStyle = ElevatedButton.styleFrom(
      onPrimary: Colors.white,
      primary: theme.primaryColor,
    );

    Widget startBtn = OutlinedButton(
      onPressed: countDown.isNotEmpty
          ? () {
              context.read<CountDownStream>().onStart();
            }
          : null,
      child: Icon(
        Icons.play_arrow_rounded,
        size: 35,
        color: theme.primaryColor,
      ),
    );

    return StreamBuilder<bool>(
      stream: countDown.isPrepare,
      initialData: true,
      builder: (context, snapshot) {
        return AnimatedCrossFade(
          crossFadeState: snapshot.data!
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: Duration(milliseconds: 500),
          firstChild: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              startBtn,
              ElevatedButton(
                onPressed: () {
                  context.read<ThemeMenuNotifier>().toggleMenu();
                },
                child: Icon(
                  Icons.palette,
                  size: 26,
                ),
                style: themeClosed ? btnStyle : selectedBtnStyle,
              ),
              ValueListenableBuilder<bool>(
                valueListenable: markTimerClosed,
                builder: (_, markTimerClosed, __) => ElevatedButton(
                  onPressed: () {
                    _markTimer.toggleBtn();
                  },
                  child: Icon(
                    Icons.menu,
                    size: 26,
                  ),
                  style: markTimerClosed ? btnStyle : selectedBtnStyle,
                ),
              ),
            ],
          ),
          secondChild: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () {
                  context.read<CountDownStream>().onStopped();
                },
                child: Icon(
                  Icons.stop_rounded,
                  size: 35,
                ),
              ),
              SizedBox(width: 18),
              StreamBuilder<bool>(
                stream: countDown.isStarted,
                builder: (context, snapshot) {
                  return Visibility(
                    visible: snapshot.data!,
                    child: OutlinedButton(
                      onPressed: () {
                        context.read<CountDownStream>().onPause();
                      },
                      child: Icon(
                        Icons.pause_rounded,
                        size: 35,
                      ),
                    ),
                    replacement: startBtn,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
