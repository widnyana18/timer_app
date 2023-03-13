import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:timer_app/controller/countDown/countdown_stream.dart';

class CountdownIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final countDown = context.watch<CountDownStream>();
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: StreamBuilder<int>(
            stream: countDown.currentStep,
            initialData: countDown.currentStep.value,
            builder: (context, snapshot) {
              return CircularStepProgressIndicator(
                padding: math.pi / 100,
                totalSteps: 150,
                currentStep: snapshot.data!,
                stepSize: 20,
                selectedColor: theme.primaryColor,
                unselectedColor: theme.colorScheme.secondaryContainer,
                child: StreamBuilder<String>(
                  stream: countDown.displayTime,
                  initialData: countDown.displayTime.value,
                  builder: (context, snapshot) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),
                        Text(
                          snapshot.data!,
                          style: theme.textTheme.displaySmall,
                        ),
                        Text(
                          countDown.timerResult,
                          style: theme.textTheme.titleSmall
                              ?.copyWith(color: theme.colorScheme.secondary),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.light_mode_rounded,
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.notifications_off_sharp,
            color: theme.colorScheme.secondary,
          ),
        ),
      ],
    );
  }
}
