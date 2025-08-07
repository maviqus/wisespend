import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class DatePickerWidget extends StatefulWidget {
  final List<DateTime?>? initialDates;
  final Function(List<DateTime?>) callBackFuntion;

  const DatePickerWidget({
    super.key,
    this.initialDates,
    required this.callBackFuntion,
  });

  @override
  State<DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  List<DateTime?> _dates = <DateTime?>[];

  @override
  void initState() {
    super.initState();
    _dates = widget.initialDates ?? <DateTime?>[];
  }

  @override
  void didUpdateWidget(covariant DatePickerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialDates != oldWidget.initialDates) {
      setState(() {
        _dates = widget.initialDates ?? <DateTime?>[];
      });
    }
  }

  void handleChangeDate() async {
    final data = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        calendarType: CalendarDatePicker2Type.range,
      ),
      dialogSize: const Size(325, 400),
      value: _dates,
      borderRadius: BorderRadius.circular(15),
    );

    // Nếu nhấn Cancel, callback rỗng nhưng KHÔNG setState để giữ lại UI hiện tại
    if (data == null) {
      widget.callBackFuntion(<DateTime?>[]);
      return;
    }

    // Nếu không chọn ngày nào
    if (data.isEmpty || data[0] == null) {
      widget.callBackFuntion(<DateTime?>[]);
      setState(() {
        _dates = <DateTime?>[];
      });
      return;
    }

    // Nếu chọn 2 ngày và ngày kết thúc < ngày bắt đầu, reset về rỗng để tránh lỗi assertion
    if (data.length > 1 &&
        data[0] != null &&
        data[1] != null &&
        data[1]!.isBefore(data[0]!)) {
      widget.callBackFuntion(<DateTime?>[]);
      setState(() {
        _dates = <DateTime?>[];
      });
      return;
    }

    if (data.length == 1 &&
        data[0] != null &&
        _dates.length == 1 &&
        _dates[0] != null) {
      final old = _dates[0]!;
      final tapped = data[0]!;
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
        SizedBox(width: 8.w),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff00D09E),
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
    );
  }
}
