import 'package:fire_login/blocs/calendar/bloc/calendar_bloc.dart';
import 'package:fire_login/blocs/calendar/bloc/calendar_event.dart';
import 'package:fire_login/blocs/calendar/bloc/calendar_state.dart';
import 'package:fire_login/screens/home/paynow/paynow.dart';
import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class Booking extends StatelessWidget {
  Booking(
      {required this.fromTime,
      required this.toTime,
      required this.uid,
      required this.fees});

  final String fromTime;
  final String toTime;
  final String uid;
  final int fees;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CalendarBloc()
        ..add(GenerateTimeSlots(
            fromTime: fromTime,
            toTime: toTime,
            uid: uid,
            selectedDay: DateTime.now())),
      child: BookingView(
        uid: uid,
        fromTime: fromTime,
        toTime: toTime,
        fees: fees,
      ),
    );
  }
}

class BookingView extends StatelessWidget {
  final String uid;
  final String fromTime;
  final String toTime;
  final int fees;

  BookingView(
      {required this.uid,
      required this.fromTime,
      required this.toTime,
      required this.fees});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: Colormanager.scaffold,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios_sharp),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colormanager.scaffold,
        title: Text(
          'Book Appointment',
          style: GoogleFonts.dongle(fontSize: 30, fontWeight: FontWeight.bold),
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
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: BlocBuilder<CalendarBloc, CalendarState>(
                builder: (context, state) {
                  DateTime focusedDay = DateTime.now();
                  DateTime? selectedDay;

                  if (state is CalendarUpdated) {
                    focusedDay = state.focusedDay;
                    selectedDay = state.selectedDay;
                  }

                  return TableCalendar(
                    calendarFormat: CalendarFormat.month,
                    focusedDay: focusedDay,
                    firstDay: DateTime.now(),
                    lastDay: DateTime(2050),
                    selectedDayPredicate: (day) {
                      return isSameDay(selectedDay, day);
                    },
                    onFormatChanged: (format) {},
                    onDaySelected: (selectedDay, focusedDay) {
                      context.read<CalendarBloc>().add(
                            CalendarDaySelected(
                              selectedDay: selectedDay,
                              focusedDay: focusedDay,
                            ),
                          );
                      context.read<CalendarBloc>().add(
                            GenerateTimeSlots(
                              fromTime: fromTime,
                              toTime: toTime,
                              uid: uid,
                              selectedDay: selectedDay,
                            ),
                          );
                    },
                    calendarStyle: CalendarStyle(
                      outsideDaysVisible: false,
                      selectedDecoration: BoxDecoration(
                        color: Colormanager.blueicon,
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
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 22, top: 20),
            child: Text(
              'Select Time',
              style: GoogleFonts.dongle(
                textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 27),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<CalendarBloc, CalendarState>(
              builder: (context, state) {
                if (state is CalendarUpdated) {
                  if (state.timeSlots.isEmpty) {
                    return Center(
                      child: Text('No available slots',
                          style: TextStyle(fontSize: 18)),
                    );
                  }

                  return GridView.builder(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.all(15),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                      childAspectRatio: 2.5,
                    ),
                    itemCount: state.timeSlots.length,
                    itemBuilder: (context, index) {
                      final timeSlot = state.timeSlots[index];
                      final String formattedTime =
                          DateFormat('h:mm a').format(timeSlot);
                      final bool isSelected =
                          state.selectedTimeSlot == timeSlot;
                      final bool isBooked =
                          state.bookedSlots.contains(timeSlot);

                      return GestureDetector(
                        onTap: () {
                          if (!isBooked) {
                            context.read<CalendarBloc>().add(
                                  TimeSlotSelected(
                                    selectedTimeSlot: timeSlot,
                                  ),
                                );
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: isSelected
                                ? Colormanager.blueicon
                                : isBooked
                                    ? Colors.grey
                                    : Colors.white,
                          ),
                          child: Text(
                            formattedTime,
                            style: TextStyle(
                              color: isSelected || isBooked
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          BlocListener<CalendarBloc, CalendarState>(
            listener: (context, state) {
              // if (state is CalendarUpdated) {
              //   // ScaffoldMessenger.of(context).showSnackBar(
              //   //   SnackBar(
              //   //     content: Text('Booking saved successfully!'),
              //   //   ),
              //   // );
              //   // Navigator.push(
              //   //   context,
              //   //   MaterialPageRoute(
              //   //     builder: (context) => PayNow(
              //   //       formtime: fromTime,
              //   //       selectedDay: state.selectedDay,
              //   //       selectedTimeSlot: state.selectedTimeSlot!,
              //   //       totime: toTime,
              //   //       uid: uid,
              //   //       fees: fees,
              //   //     ),
              //   //   ),
              //   // );
              // } else if (state is CalendarError) {
              //   ScaffoldMessenger.of(context).showSnackBar(
              //     SnackBar(
              //       content: Text('Failed to save booking: ${state.message}'),
              //     ),
              //   );
              // }
            },
            child: Center(
              child: ElevatedButton(
                style: ButtonStyle(
                  minimumSize: WidgetStateProperty.all(
                    Size(mediaQuery.size.width * 0.9, 50),
                  ),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  backgroundColor:
                      WidgetStateProperty.all(Colormanager.blueicon),
                ),
                onPressed: () {
                  final currentState = context.read<CalendarBloc>().state;
                  if (currentState is CalendarUpdated &&
                      currentState.selectedTimeSlot != null) {
                    // context.read<CalendarBloc>().add(
                    //       SaveBooking(
                    //         selectedDay: currentState.selectedDay,
                    //         selectedTimeSlot: currentState.selectedTimeSlot!,
                    //         fromTime: fromTime,
                    //         toTime: toTime,
                    //         uid: uid,
                    //       ),
                    //     );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PayNow(
                          formtime: fromTime,
                          selectedDay: currentState.selectedDay,
                          selectedTimeSlot: currentState.selectedTimeSlot!,
                          totime: toTime,
                          uid: uid,
                          fees: fees,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: Duration(seconds: 1),
                        backgroundColor: Colormanager.blackIcon,
                        margin:
                            EdgeInsets.only(left: 10, right: 10, bottom: 10),
                        behavior: SnackBarBehavior.floating,
                        content: Text('Please select a time slot'),
                      ),
                    );
                  }
                },
                child: Text(
                  'Next',
                  style: GoogleFonts.dongle(
                    textStyle: TextStyle(
                        color: Colormanager.whiteText,
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
