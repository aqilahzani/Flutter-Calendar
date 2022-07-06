import 'package:flutter/material.dart';
import './date_utils.dart';
import './clean_calendar_event.dart';
import "package:intl/intl.dart";

class CalendarTile extends StatelessWidget {
  final VoidCallback? onDateSelected;
  final DateTime? date;
  final String? dayOfWeek;
  final bool isDayOfWeek;
  final bool isSelected;
  final bool inMonth;
  final List<CleanCalendarEvent>? events;
  final TextStyle? dayOfWeekStyle;
  final TextStyle? dateStyles;
  final Widget? child;
  final Color? selectedColor;
  final Color? todayColor;
  final Color? eventColor;
  final Color? eventDoneColor;

  CalendarTile({
    this.onDateSelected,
    this.date,
    this.child,
    this.dateStyles,
    this.dayOfWeek,
    this.dayOfWeekStyle,
    this.isDayOfWeek: false,
    this.isSelected: false,
    this.inMonth: true,
    this.events,
    this.selectedColor,
    this.todayColor,
    this.eventColor,
    this.eventDoneColor,
  });

  /// This function [renderDateOrDayOfWeek] renders the week view or the month view. It is
  /// responsible for displaying a calendar tile. This can be a day (i.e. "Mon", "Tue" ...) in
  /// the header row or a date tile for each day of a week or a month. The property [isDayOfWeek]
  /// of the [CalendarTile] decides, if the rendered item should be a day or a date tile.
  Widget renderDateOrDayOfWeek(BuildContext context) {
    // We decide, if this calendar tile should display a day name in the header row. If this is the
    // case, we return a widget, that contains a text widget with style property [dayOfWeekStyle]
    if (isDayOfWeek) {
      return InkWell(
        child: Container(
          alignment: Alignment.center,
          child: Text(
            dayOfWeek ?? '',
            style: dayOfWeekStyle,
          ),
        ),
      );
    } else {
      // Here the date tiles get rendered. Initially eventCount is set to 0.
      // Every date tile can show up to three dots representing an event.
      int eventCount = 0;
      return InkWell(
        onTap: onDateSelected, // react on tapping
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Container(
            // If this tile is the selected date, draw a colored circle on it. The circle is filled with
            // the color passed with the selectedColor parameter or red color.
            decoration: isSelected && date != null
                ? BoxDecoration(
                    shape: BoxShape.circle,
                    color: selectedColor != null
                        ? Utils.isSameDay(date!, DateTime.now())
                            ? Colors.orangeAccent[200]
                            : selectedColor
                        : Theme.of(context).primaryColor,
                  )
                : const BoxDecoration(), // no decoration when not selected
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Date display
                Text(
                  date != null ? DateFormat("d").format(date!) : '',
                  style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: isSelected && date != null
                          ? Colors.white
                          : Utils.isSameDay(date!, DateTime.now())
                              ? todayColor
                              : inMonth
                                  ? Colors.black
                                  : Colors
                                      .grey), // Grey color for previous or next months dates
                ),
                // Dots for the events
                events != null && events!.length > 0
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: events!.map((event) {
                          eventCount++;
                          // Show a maximum of 3 dots.
                          if (eventCount > 3) return Container();
                          return Container(
                            margin: const EdgeInsets.only(
                                left: 2.0, right: 2.0, top: 1.0),
                            width: 5.0,
                            height: 5.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                // If event is done (isDone == true) set the color of the dots to
                                // the eventDoneColor (if given) otherwise use the primary color of
                                // the theme
                                // If the event is now donw yet, we use the given eventColor or the
                                // color property of the CleanCalendarEvent. If both aren't set, then
                                // the accent color of the theme get used.
                                color: (() {
                                  if (event.isDone) {
                                    return eventDoneColor ??
                                        Theme.of(context).primaryColor;
                                  }
                                  if (isSelected) return Colors.white;
                                  return eventColor ??
                                      Theme.of(context).accentColor;
                                }())),
                          );
                        }).toList())
                    : Container(),
              ],
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // If a child widget was passed as parameter, this widget gets used to
    // be rendered to display weekday or date
    if (child != null) {
      return InkWell(
        onTap: onDateSelected,
        child: child,
      );
    }
    return Container(
      child: renderDateOrDayOfWeek(context),
    );
  }
}
