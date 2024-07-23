import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CanceledAppointments extends StatelessWidget { 
  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    FirebaseAuth _auth = FirebaseAuth.instance;
      final cancelledCollection = _firestore.collection('userbooking').doc(_auth.currentUser!.uid).collection('canceledappoinement');

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200], 
        body: StreamBuilder(
          stream: cancelledCollection.snapshots(),
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
                child: Text('No canceled appointments.'),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var appointment = snapshot.data!.docs[index];

                return Padding(
                  padding: const EdgeInsets.only(left: 13,right: 13,top: 12),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.19,
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
                                      appointment['name'],
                                      overflow: TextOverflow.fade,
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
}
  