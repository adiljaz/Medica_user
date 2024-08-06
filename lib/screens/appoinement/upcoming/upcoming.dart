import 'package:fire_login/blocs/savedoctor/savedoctor_bloc.dart';
import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpcomingAppointments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth _auth = FirebaseAuth.instance;
    final currentUser = _auth.currentUser;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('userbooking')
              .where('uid', isEqualTo: currentUser?.uid)
              .snapshots(),
          builder: (context, snapshot) {
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

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
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
                  child: _AnimatedAppointmentCard(
                    appointment: appointment,
                    onCancel: () => _showCancelDialog(
                      context,
                      appointment.id,
                      appointment['uid'],
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

  void _showCancelDialog(BuildContext context, String appointmentId, String doctorId) {
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
                await _cancelAppointment(appointmentId, doctorId);
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
        final doctorRef = FirebaseFirestore.instance.collection('doctor').doc(doctorId);
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
    }
  }
}

class _AnimatedAppointmentCard extends StatelessWidget {
  final QueryDocumentSnapshot appointment;
  final VoidCallback onCancel;

  const _AnimatedAppointmentCard({
    Key? key,
    required this.appointment,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);

    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300),
      builder: (context, opacity, child) {
        return Opacity(
          opacity: opacity,
          child: Container(
            height: mediaQuery.size.height * 0.25,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
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
                        padding: const EdgeInsets.only(left: 8, top: 12),
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
                GestureDetector(
                  onTap: onCancel,
                  child: Container(
                    width: mediaQuery.size.width * 0.85,
                    height: mediaQuery.size.height * 0.05,
                    decoration: BoxDecoration(
                      color: Colormanager.blueContainer,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Center(
                      child: Text(
                        'Cancel Appointment',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colormanager.whiteText,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}