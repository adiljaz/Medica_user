import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class UpcomingAppointments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('userbooking').snapshots(),
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
                                padding: const EdgeInsets.only(left: 8, top: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      appointment['name'],
                                      overflow: TextOverflow.fade,
                                      maxLines: 1,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 19,
                                      ),
                                    ),
                                    Container(
                                      width: mediaQuery.size.width * 0.25,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
                                        border: Border.all(
                                          color: Colormanager.blueContainer,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Upcoming',
                                          style: GoogleFonts.poppins(
                                            color: Colormanager.blueContainer,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Department: ${appointment['department']}',
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Date: ${appointment['selectedDay']}',
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Time: ${appointment['selectedTimeSlot']}',
                                      style: GoogleFonts.poppins(
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
                            Container(
                              child: Center(
                                child: Text(
                                  'Reschedule',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colormanager.whiteText,
                                  ),
                                ),
                              ),
                              width: mediaQuery.size.width * 0.4,
                              height: mediaQuery.size.height * 0.05,
                              decoration: BoxDecoration(
                                color: Colormanager.blueContainer,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _showCancelDialog(context, appointment.id);
                              },
                              child: Container(
                                child: Center(
                                  child: Text(
                                    'Cancel Appointment',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colormanager.blueText,
                                    ),
                                  ),
                                ),
                                width: mediaQuery.size.width * 0.44,
                                height: mediaQuery.size.height * 0.05,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 2,
                                    color: Colormanager.blueContainer,
                                  ),
                                  color: Colormanager.whiteContainer,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    height: mediaQuery.size.height * 0.25,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context, String appointmentId) {
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
                await _cancelAppointment(appointmentId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _cancelAppointment(String appointmentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('userbooking')
          .doc(appointmentId)
          .delete();

      // Optionally, you can add additional logic to remove from other collections if needed
    } catch (e) {
      print(e);
    }
  }
}
