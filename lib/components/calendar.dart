import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  final Function(DateTime)? onDaySelected;

  const Calendar({Key? key, this.onDaySelected}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TableCalendar(
        firstDay: DateTime.utc(2000, 1, 1),
        lastDay: DateTime.utc(2100, 12, 31),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
          leftChevronIcon: const Icon(Icons.chevron_left, size: 20),
          rightChevronIcon: const Icon(Icons.chevron_right, size: 20),
          titleTextStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        daysOfWeekStyle: const DaysOfWeekStyle(
          weekdayStyle: TextStyle(fontSize: 12, color: Colors.grey),
          weekendStyle: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(color: Colors.blue.shade100, shape: BoxShape.circle),
          selectedDecoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
          selectedTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          outsideDaysVisible: true,
        ),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
          if (widget.onDaySelected != null) widget.onDaySelected!(selectedDay);
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
      ),
    );
  }
}
