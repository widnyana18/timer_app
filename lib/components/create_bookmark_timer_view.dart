import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:timer_app/controller/mark_timer/mark_timer_stream.dart';

class CreateBookmarkTimerView extends StatelessWidget {
  Widget build(BuildContext context) {
    final markTimer = context.watch<MarkTimerStream>();
    final theme = Theme.of(context);
    final txtTheme = theme.textTheme;
    return Padding(
      padding: EdgeInsets.all(26),
      child: Column(
        children: [
          Text(
            'Frequently used timer',
            style: txtTheme.bodyMedium,
          ),
          SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              2,
              (index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder<int>(
                    stream: index == 0
                        ? markTimer.presetHours
                        : markTimer.presetMinutes,
                    initialData: 0,
                    builder: (context, snapshot) {
                      return NumberPicker(
                        value: snapshot.data!,
                        minValue: 0,
                        maxValue: index == 0 ? 23 : 59,
                        onChanged: index == 0
                            ? context.read<MarkTimerStream>().setHours
                            : context.read<MarkTimerStream>().setMinutes,
                        infiniteLoop: true,
                        haptics: true,
                        zeroPad: true,
                        itemCount: 3,
                        selectedTextStyle: txtTheme.titleMedium,
                        textStyle: txtTheme.titleSmall,
                      );
                    }),
              ),
            )..insert(
                1,
                VerticalDivider(
                  color: Colors.white38,
                )),
          ),
          SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                  style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                    side: BorderSide.none,
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: !markTimer.isEmpty
                      ? () {
                          markTimer.create();
                        }
                      : null,
                  child: Text('Okok'),
                  style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                    side: BorderSide.none,
                    textStyle: txtTheme.bodyMedium
                        ?.copyWith(color: theme.primaryColor),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
