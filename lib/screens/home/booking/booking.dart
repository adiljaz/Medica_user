import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:table_calendar/table_calendar.dart';

class Booking extends StatefulWidget {
  Booking({required this.toTime, required this.fromTime});

  final String fromTime;
  final String toTime;

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  late DateTime selectedSlot;
  late List<DateTime> timeSlots=[]; // Declare timeSlots without initialization

  @override
  void initState() {
    super.initState();
    selectedSlot = DateTime.now();
    timeSlots = generateTimeSlots(); // Initialize timeSlots in initState
  }

  List<DateTime> generateTimeSlots() {
    final Duration slotDuration = const Duration(minutes: 30);
    List<DateTime> slots = [];

    try {
      DateTime fromDateTime = DateFormat('HH:mm').parse(widget.fromTime);
      DateTime toDateTime = DateFormat('HH:mm').parse(widget.toTime);

      while (fromDateTime.isBefore(toDateTime)) {
        slots.add(fromDateTime);
        fromDateTime = fromDateTime.add(slotDuration);
      }
    } catch (e) {
      print('Invalid date format: $e');
    }

    return slots;
  }

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Colormanager.scaffold,
      appBar: AppBar(
        backgroundColor: Colormanager.scaffold,
        title: Text(
          'Book Appointment',
          style: GoogleFonts.dongle(fontSize: 24),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: mediaQuery.size.width * 0.86,
              decoration: BoxDecoration(
                  color: Colormanager.lightblue,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: TableCalendar(
                calendarFormat: _calendarFormat,
                focusedDay: _focusedDay,
                firstDay: DateTime.now(),
                lastDay: DateTime(2050),
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false,
                  selectedDecoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: TextStyle(color: Colors.white),
                  todayTextStyle: TextStyle(color: Colors.black),
                ),
                headerStyle: HeaderStyle(
                  titleTextStyle: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 22, top: 20),
            child: Text(
              'Select Time',
              style: GoogleFonts.dongle(
                  textStyle:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 27)),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: timeSlots.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(
                    DateFormat('h:mm a').format(timeSlots[index]),
                    style: TextStyle(fontSize: 18),
                  ),
                  onTap: () {
                    setState(() {
                      selectedSlot = timeSlots[index];
                      // Add your logic for handling the selected time slot
                    });
                  },
                  selected: selectedSlot == timeSlots[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
