import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer_app/components/create_bookmark_timer_view.dart';
import 'package:timer_app/controller/mark_timer/mark_timer_stream.dart';

class BookmarkTimerSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final markTimer = context.watch<MarkTimerStream>();
    final theme = Theme.of(context);
    final txtTheme = theme.textTheme;

    return ValueListenableBuilder<bool>(
        valueListenable: markTimer.isClosed,
        builder: (context, isClosed, _) {
          return AnimatedOpacity(
            opacity: isClosed ? 0 : 1,
            duration: Duration(seconds: 1),
            child: SizedBox(
              height: 65,
              child: StreamBuilder<List<int>>(
                  stream: markTimer.minutesData,
                  initialData: markTimer.minutesData.value,
                  builder: (context, snap) {
                    final minutes = snap.data!;
                    return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: index == minutes.length
                              ? ElevatedButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      backgroundColor: theme.canvasColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(12)),
                                      ),
                                      context: context,
                                      builder: (context) =>
                                          CreateBookmarkTimerView(),
                                      enableDrag: false,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary:
                                        theme.colorScheme.secondaryContainer,
                                    side: BorderSide.none,
                                  ),
                                  child: Icon(
                                    Icons.add_rounded,
                                    color: theme.colorScheme.secondary,
                                  ),
                                )
                              : ElevatedButton(
                                  onPressed: () {
                                    markTimer.select(index);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary:
                                        theme.colorScheme.secondaryContainer,
                                    side: BorderSide.none,
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        minutes[index].toString(),
                                        style: txtTheme.titleLarge,
                                      ),
                                      SizedBox(height: 6),
                                      Text(
                                        'mnt',
                                        style: txtTheme.bodyMedium,
                                      ),
                                    ],
                                  ),
                                ),
                        );
                      },
                      itemCount: minutes.length + 1,
                      scrollDirection: Axis.horizontal,
                    );
                  }),
            ),
          );
        });
  }
}
