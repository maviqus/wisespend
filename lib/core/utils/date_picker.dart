import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';

void getDatePickerCustom(List<DateTime?> dates, BuildContext context) async {
  await showCalendarDatePicker2Dialog(
    context: context,
    config: CalendarDatePicker2WithActionButtonsConfig(
      calendarType: CalendarDatePicker2Type.range,
    ),
    dialogSize: const Size(325, 400),
    value: dates,
    borderRadius: BorderRadius.circular(15),
  );
}
