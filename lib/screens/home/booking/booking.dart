import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_login/blocs/calendar/bloc/calendar_bloc.dart';
import 'package:fire_login/blocs/calendar/bloc/calendar_event.dart';
import 'package:fire_login/blocs/calendar/bloc/calendar_state.dart';
import 'package:fire_login/screens/home/discription/discription.dart';
import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class Booking extends StatelessWidget {
  Booking({required this.fromTime, required this.toTime, required this.uid});

  final String fromTime;
  final String toTime;
  final String uid; 

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CalendarBloc()..add(GenerateTimeSlots(fromTime: fromTime, toTime: toTime)),
      child: BookingView(),
    );
  }
}

class BookingView extends StatelessWidget {

      // final CollectionReference userCollection =
      //   FirebaseFirestore.instance.collection('users');

      
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
            icon: Icon(Icons.arrow_back_ios_sharp)),
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
                  borderRadius: BorderRadius.all(Radius.circular(20))),
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
                      context.read<CalendarBloc>().add(CalendarDaySelected(
                          selectedDay: selectedDay,
                          focusedDay: focusedDay));
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
                  textStyle:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 27)),
            ),
          ),
          Expanded(
            child: BlocBuilder<CalendarBloc, CalendarState>(
              builder: (context, state) {
                if (state is CalendarUpdated) {
                  if (state.timeSlots.isEmpty) {
                    return Center(
                        child: Text('No available slots',
                            style: TextStyle(fontSize: 18)));
                  }

                  return GridView.builder(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.only(left: 22, right: 22),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 5 / 2),
                    itemCount: state.timeSlots.length,
                    itemBuilder: (BuildContext context, int index) {
                      final timeSlot = state.timeSlots[index];
                      final isSelected = state.selectedTimeSlot == timeSlot;

                      return GestureDetector(
                        onTap: () {
                          context.read<CalendarBloc>().add(TimeSlotSelected(selectedTimeSlot: timeSlot));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected ? Colormanager.blueContainer : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: isSelected ?Colormanager.blueContainer: Colormanager.blueContainer,
                                width: 2),
                          ),
                          child: Center(
                            child: Text(
                              DateFormat('h:mm a').format(timeSlot),
                              style: GoogleFonts.dongle(
                                  fontSize: 25,
                                  color: isSelected ? Colors.white : Colormanager.blueText),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is CalendarError) {
                  return Center(
                      child: Text('Error: ${state.message}',
                          style: TextStyle(fontSize: 18)));
                }

                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(PageTransition(
                  child: Description(), type: PageTransitionType.fade));
            },
            child: Center(
              child: Container(
                height: mediaQuery.size.height * 0.07,
                decoration: BoxDecoration(
                    color: Colormanager.blueContainer,
                    borderRadius: BorderRadius.circular(50)),
                width: mediaQuery.size.width * 0.9,
                child: Center(
                    child: Text(
                  'Next',
                  style: GoogleFonts.dongle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colormanager.whiteText),
                )),
              ),
            ),
          ),
          SizedBox(
            height: mediaQuery.size.height * 0.01,
          )
        ],
      ),
    );
  }
  
}
