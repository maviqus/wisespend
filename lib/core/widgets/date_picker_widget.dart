import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:intl/intl.dart';

class DatePickerWidget extends StatefulWidget {
  final Function(List<DateTime?>) callBackFuntion;
  final List<DateTime?> initialDates;

  const DatePickerWidget({
    super.key,
    required this.callBackFuntion,
    this.initialDates = const [],
  });

  @override
  State<DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  List<DateTime?> _dates = [];

  @override
  void initState() {
    super.initState();
    _dates = List.from(widget.initialDates);
  }

  void handleChangeDate() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Chọn ngày',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: CalendarDatePicker2(
            config: CalendarDatePicker2Config(
              calendarType: CalendarDatePicker2Type.range,
              selectedDayHighlightColor: const Color(0xFF4CAF50),
              weekdayLabelTextStyle: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
              firstDayOfWeek: 1,
              controlsHeight: 50,
              dayBuilder:
                  ({
                    required date,
                    textStyle,
                    decoration,
                    isSelected,
                    isDisabled,
                    isToday,
                  }) {
                    Widget? dayWidget;
                    if (date.day % 3 == 0 && date.day % 9 != 0) {
                      dayWidget = Container(
                        decoration: decoration,
                        child: Center(
                          child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Text(
                                MaterialLocalizations.of(
                                  context,
                                ).formatDecimal(date.day),
                                style: textStyle,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 27.5),
                                child: Container(
                                  height: 4,
                                  width: 4,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: isSelected == true
                                        ? Colors.white
                                        : Colors.grey[500],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return dayWidget;
                  },
            ),
            value: _dates,
            onValueChanged: (data) {
              if (data.length > 1 && data[1].isBefore(data[0])) {
                widget.callBackFuntion(<DateTime?>[]);
                setState(() {
                  _dates = <DateTime?>[];
                });
                return;
              }

              // Nếu chỉ chọn 1 ngày và ngày đó đã được chọn trước đó, bỏ chọn
              if (data.length == 1 && _dates.length == 1 && _dates[0] != null) {
                final old = _dates[0]!;
                final tapped = data[0];
                if (old.year == tapped.year &&
                    old.month == tapped.month &&
                    old.day == tapped.day) {
                  widget.callBackFuntion(<DateTime?>[]);
                  setState(() {
                    _dates = <DateTime?>[];
                  });
                  return;
                }
              }

              widget.callBackFuntion(data);
              setState(() {
                _dates = data;
              });
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Hủy',
              style: TextStyle(color: Colors.grey[600], fontSize: 16.sp),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            ),
            onPressed: () {
              widget.callBackFuntion(<DateTime?>[]);
              setState(() {
                _dates = <DateTime?>[];
              });
            },
            child: Text(
              'Hiện tất cả',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String text;
    if (_dates.isNotEmpty && _dates[0] != null) {
      if (_dates.length > 1 && _dates[1] != null) {
        text =
            '${DateFormat('dd/MM/yyyy').format(_dates[0]!)} - ${DateFormat('dd/MM/yyyy').format(_dates[1]!)}';
      } else {
        text = DateFormat('dd/MM/yyyy').format(_dates[0]!);
      }
    } else {
      text = 'Chọn ngày';
    }

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: handleChangeDate,
            child: Container(
              height: 48.h,
              decoration: BoxDecoration(
                color: const Color(0xFFE6F7EE),
                borderRadius: BorderRadius.circular(20.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(text),
                  Icon(Icons.calendar_today, size: 20.sp),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
