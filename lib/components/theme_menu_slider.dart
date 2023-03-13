import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer_app/controller/theme_menu_notifier.dart';

class ThemeMenuSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeMenu = context.watch<ThemeMenuNotifier>();
    final theme = Theme.of(context);

    return AnimatedOpacity(
      opacity: themeMenu.isClosed ? 0 : 1,
      duration: Duration(seconds: 1),
      child: SizedBox(
        height: 55,
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 25),
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: InkWell(
                onTap: () {
                  context.read<ThemeMenuNotifier>().changeTheme(index);
                },
                child: Column(
                  children: [
                    Icon(
                      cover[index].icon,
                      size: 22,
                      color: themeMenu.selectedTheme == index
                          ? theme.primaryColor
                          : theme.colorScheme.secondary,
                    ),
                    SizedBox(height: 6),
                    Text(
                      cover[index].label!,
                      style: TextStyle(
                        fontSize: 12,
                        color: themeMenu.selectedTheme == index
                            ? theme.primaryColor
                            : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          itemCount: cover.length,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }
}

List<MoodData> cover = [
  MoodData(
    icon: Icons.notifications,
    label: 'Default',
    cover: '',
  ),
  MoodData(
    icon: Icons.cloudy_snowing,
    label: 'Summer rain',
    cover: 'rain.jpg',
  ),
  MoodData(
    icon: Icons.nights_stay_rounded,
    label: 'Summer night',
    cover: 'night.jpg',
  ),
  MoodData(
    icon: Icons.forest,
    label: 'Forest',
    cover: 'forest.jpg',
  ),
  MoodData(
    icon: Icons.beach_access_rounded,
    label: 'Beach',
    cover: 'beach.jpg',
  ),
  MoodData(
    icon: Icons.local_fire_department,
    label: 'Campfire',
    cover: 'campfire.jpg',
  ),
];

class MoodData {
  final IconData? icon;
  final String? label;
  final String? cover;

  MoodData({this.icon, this.label, this.cover});
}
