import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer_app/components/components.dart';
import 'package:timer_app/controller/controllers.dart';

class CountDownView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isPrepare = context
        .select<CountDownStream, Stream<bool>>((value) => value.isPrepare);
    final markTimerClosed =
        context.select<MarkTimerStream, ValueNotifier<bool>>(
            (value) => value.isClosed);
    final themeMenu = context.watch<ThemeMenuNotifier>();
    final txtTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          context.read<MarkTimerStream>().closeMarkTimer();
          context.read<ThemeMenuNotifier>().closeMenu();
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/images/${cover[themeMenu.selectedTheme].cover}'),
              fit: BoxFit.cover,
              opacity: .2,
            ),
            color: Colors.black,
          ),
          child: Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.hourglass_top_rounded,
                    size: 18,
                  ),
                ),
                title: Text(
                  'Pomodoro timer',
                  style: txtTheme.titleMedium,
                ),
                trailing: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.more_vert, size: 18),
                ),
              ),
              Spacer(),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'CURRENT TASK\n',
                  style: TextStyle(
                    height: 1.7,
                    letterSpacing: 2,
                    color: Colors.white38,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                  children: [
                    TextSpan(
                      text: 'Pomodoro mobile app design',
                      style: txtTheme.titleLarge,
                    ),
                  ],
                ),
              ),
              Spacer(),
              Expanded(
                flex: 9,
                child: StreamBuilder<bool>(
                    stream: isPrepare,
                    builder: (context, snapshot) {
                      return AnimatedCrossFade(
                        crossFadeState: snapshot.data!
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        duration: Duration(seconds: 1),
                        firstChild: PresetTimerSlider(),
                        secondChild: CountdownIndicator(),
                      );
                    }),
              ),
              Spacer(),
              ValueListenableBuilder<bool>(
                valueListenable: markTimerClosed,
                builder: (_, value, __) {
                  if (!themeMenu.isClosed || value) {
                    return ThemeMenuSlider();
                  }
                  return BookmarkTimerSlider();
                },
              ),
              Spacer(),
              CountDownActBtn(),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
