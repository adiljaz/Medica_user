import 'package:fire_login/blocs/savedoctor/savedoctor_bloc.dart';
import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

class UpcomingAppointments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection('userbooking').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text('No appointments yet.'),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var appointment = snapshot.data!.docs[index];

                return Padding(
                  padding: const EdgeInsets.all(13),
                  child: Container(
                    height: mediaQuery.size.height * 0.25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Container(
                                height: mediaQuery.size.height * 0.145,
                                width: mediaQuery.size.width * 0.3,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.network(
                                    appointment['image'] ?? '',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, top: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      appointment['name'],
                                      overflow: TextOverflow.fade,
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 19,
                                      ),
                                    ),
                                    Container(
                                      width: mediaQuery.size.width * 0.25,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
                                        border: Border.all(
                                          color: Colors.blue,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Upcoming',
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Department: ${appointment['department']}',
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Date: ${appointment['selectedDay']}',
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Time: ${appointment['selectedTimeSlot']}',
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: Divider(),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {
                                showBottomSheet(
                                  context: context,
                                  builder: (context) => Container(
                                    height: mediaQuery.size.height * 0.3,
                                    width: mediaQuery.size.width,
                                    decoration: BoxDecoration(
                                        color: Colormanager.whiteContainer,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(50),
                                            topRight: Radius.circular(50))),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: mediaQuery.size.height * 0.02,
                                        ),
                                        Text(
                                          'Reschedule Appoinement',
                                          style: GoogleFonts.dongle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 33,
                                              color: Colormanager.blueText),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 12, right: 12),
                                          child: Divider(),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20.0, right: 20, top: 30),
                                          child: Text(
                                            '''Are you sure you want to Reschedule  Appoinement ?''',
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                        ),
                                        Spacer(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Container(
                                                width:
                                                    mediaQuery.size.width * 0.4,
                                                height: mediaQuery.size.height *
                                                    0.05,
                                                decoration: BoxDecoration(
                                                  color: Color.fromARGB(
                                                      255, 216, 237, 255),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'Back',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          Colormanager.blueText,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).pop();
                                               
                                                _cancelAppointment(
                                                    appointment.id,
                                                    appointment['uid']);
                                              },
                                              child: Container(
                                                width:
                                                    mediaQuery.size.width * 0.4,
                                                height: mediaQuery.size.height *
                                                    0.05,
                                                decoration: BoxDecoration(
                                                  color: Colors.blue,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'Reschedule',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height:
                                              mediaQuery.size.height * 0.025,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: mediaQuery.size.width * 0.4,
                                height: mediaQuery.size.height * 0.05,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                    'Reschedule',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _showCancelDialog(context, appointment.id,
                                    appointment['uid']);
                              },
                              child: Container(
                                width: mediaQuery.size.width * 0.44,
                                height: mediaQuery.size.height * 0.05,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 2,
                                    color: Colors.blue,
                                  ),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                    'Cancel Appointment',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _showCancelDialog(
      BuildContext context, String appointmentId, String doctorId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cancel Appointment'),
          content: Text('Do you want to cancel this appointment?'),
          actions: [
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () async {
                _cancelAppointment(appointmentId, doctorId);
                final saveDoctorBloc = BlocProvider.of<SaveDoctorBloc>(context);
                saveDoctorBloc.onCancelAppointment(appointmentId, doctorId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showCResheduleDialog(
      BuildContext context, String appointmentId, String doctorId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cancel Appointment'),
          content: Text('Do you want to cancel this appointment?'),
          actions: [
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () async {
                _cancelAppointment(appointmentId, doctorId);
                final saveDoctorBloc = BlocProvider.of<SaveDoctorBloc>(context);
                saveDoctorBloc.onCancelAppointment(appointmentId, doctorId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _cancelAppointment(String appointmentId, String doctorId) async {
    try {
      final appointmentSnapshot = await FirebaseFirestore.instance
          .collection('userbooking')
          .doc(appointmentId)
          .get();

      if (appointmentSnapshot.exists) {
        final selectedDay = appointmentSnapshot['selectedDay'];
        final selectedTimeSlot = appointmentSnapshot['selectedTimeSlot'];

        // Delete the appointment from 'userbooking' collection
        await appointmentSnapshot.reference.delete();

        // Now free up the time slot in the doctor's 'dailyBookings' collection
        final doctorRef =
            FirebaseFirestore.instance.collection('doctor').doc(doctorId);
        final dailyBookingRef = doctorRef.collection('dailyBookings');
        final bookedSlot = await dailyBookingRef
            .where('selectedDay', isEqualTo: selectedDay)
            .where('selectedTimeSlot', isEqualTo: selectedTimeSlot)
            .get();

        if (bookedSlot.docs.isNotEmpty) {
          await bookedSlot.docs.first.reference.delete();
        }
      }
    } catch (e) {
      print('Error cancelling appointment: $e');
      // Handle error here
    }
  }
}
