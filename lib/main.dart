import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer_app/config/app_theme.dart';
import 'package:timer_app/controller/controllers.dart';
import 'package:timer_app/view/countdown_view.dart';

void main() {
  runApp(MainPage());
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Timer App Xiaomi',
      themeMode: ThemeMode.dark,
      darkTheme: AppTheme.dark,
      home: MultiProvider(
        providers: [
          Provider<CountDownStream>(
            create: (context) => CountDownStream(),
          ),
          Provider<PresetTimerStream>(
            create: (context) => PresetTimerStream(),
          ),
          Provider<MarkTimerStream>(
            create: (context) => MarkTimerStream(
              closeThemeMenu: context.read<ThemeMenuNotifier>().closeMenu,
            ),
          ),
          ChangeNotifierProvider<ThemeMenuNotifier>(
            create: (_) => ThemeMenuNotifier(),
          ),
        ],
        child: CountDownView(),
      ),
    );
  }
}
