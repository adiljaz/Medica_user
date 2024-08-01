import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CanceledAppointments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    FirebaseAuth _auth = FirebaseAuth.instance;
    final userId = _auth.currentUser!.uid;

    return SafeArea(
      child: Scaffold(
       
        backgroundColor: Colors.grey[200],
        body: FutureBuilder<List<DocumentSnapshot>>(
          future: _getCanceledAppointments(_firestore, userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No canceled appointments.'));
            }

            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var appointment = snapshot.data![index];
                return _buildAppointmentCard(context, appointment);
              },
            );
          },
        ),
      ),
    );
  }

  Future<List<DocumentSnapshot>> _getCanceledAppointments(FirebaseFirestore firestore, String userId) async {
    final userCanceled = await firestore.collection('userbooking').doc(userId).collection('canceledappoinement').get();
    final doctorCanceled = await firestore.collection('users').doc(userId).collection('canceledAppointments').get();
    
    List<DocumentSnapshot> allCanceled = [...userCanceled.docs, ...doctorCanceled.docs];
    return allCanceled;
  }

  Widget _buildAppointmentCard(BuildContext context, DocumentSnapshot appointment) {
    return Padding(
      padding: const EdgeInsets.only(left: 13, right: 13, top: 12),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.19,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.145,
                width: MediaQuery.of(context).size.width * 0.3,
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
                      appointment['name'] ?? 'N/A',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontWeight: FontWeight.bold, 
                        fontSize: 19,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        border: Border.all(
                          color: Colors.red,
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Canceled',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Department: ${appointment['department'] ?? 'N/A'}',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Date: ${_formatDate(appointment['selectedDay'])}',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Time: ${appointment['selectedTimeSlot'] ?? 'N/A'}',
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
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM d, yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }
} 