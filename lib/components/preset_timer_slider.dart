import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:timer_app/controller/controllers.dart';

class PresetTimerSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final txtTheme = Theme.of(context).textTheme;
    final countDown = context.watch<CountDownStream>();
    final presetTimer = context.watch<PresetTimerStream>();

    void setHours(int value) {
      context.read<CountDownStream>().fetchHours(value);
    }

    void setMinute(int value) {
      context.read<CountDownStream>().fetchMinutes(value);
    }

    void setSecond(int value) {
      context.read<CountDownStream>().fetchSeconds(value);
    }

    String fetchBeforeAfterHours(String value) {
      context.read<PresetTimerStream>().getAllHoursItems(value);
      return value;
    }

    String fetchBeforeAfterMin(String value) {
      context.read<PresetTimerStream>().getAllMinItems(value);
      return value;
    }

    String fetchBeforeAfterSec(String value) {
      context.read<PresetTimerStream>().getAllSecItems(value);
      return value;
    }

    const List<int> format = [24, 60, 60];

    return Row(
      children: List.generate(
        3,
        (listIdx) => Flexible(
          flex: 3,
          child: StreamBuilder<int>(
            stream: listIdx == 0
                ? countDown.hours
                : listIdx == 1
                    ? countDown.minutes
                    : countDown.seconds,
            initialData: 0,
            builder: (context, timer) {
              return StreamBuilder<bool>(
                stream: presetTimer.isBeforeAfterVal,
                initialData: false,
                builder: (context, isBeforeAfterVal) {
                  return NumberPicker(
                    value: timer.data!,
                    minValue: 0,
                    textMapper: listIdx == 0
                        ? fetchBeforeAfterHours
                        : listIdx == 1
                            ? fetchBeforeAfterMin
                            : fetchBeforeAfterSec,
                    maxValue: format[listIdx] - 1,
                    onChanged: listIdx == 0
                        ? setHours
                        : listIdx == 1
                            ? setMinute
                            : setSecond,
                    infiniteLoop: true,
                    haptics: true,
                    zeroPad: true,
                    itemCount: 5,
                    selectedTextStyle: txtTheme.displaySmall,
                    textStyle: isBeforeAfterVal.data!
                        ? txtTheme.headlineMedium!
                        : txtTheme.headlineSmall!,
                  );
                },
              );
            },
          ),
        ),
      )
        ..insert(
            1,
            VerticalDivider(
              color: Colors.white38,
            ))
        ..insert(
            2,
            VerticalDivider(
              color: Colors.white38,
            )),
    );
  }
}
