import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_login/blocs/Favorite/favorite_bloc.dart';
import 'package:fire_login/screens/home/drdetails/details.dart';
import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';

class Favourite extends StatelessWidget {
  const Favourite({Key? key});

  @override
  Widget build(BuildContext context) {
    final FavoriteBloc favoriteBloc = FavoriteBloc();
    final doctor = FirebaseFirestore.instance.collection('doctor');

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Doctors'),
      ),
      body: StreamBuilder(
        stream: doctor.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error fetching data'));
          }

          if (!snapshot.hasData || (snapshot.data as QuerySnapshot).docs.isEmpty) {
            return Center(child: Text('No favorite doctors'));
          }

          return ListView.builder(
            itemCount: (snapshot.data as QuerySnapshot).docs.length,
            itemBuilder: (context, index) {
              final doctor = (snapshot.data as QuerySnapshot).docs[index];
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => DrDetails(
                      about: doctor['about'],
                      departmnet: doctor['department'],
                      experiance: doctor['experience'],
                      fees: doctor['fees'],
                      from: doctor['from'],
                      hospital: doctor['hospitalName'],
                      imageUrl: doctor['imageUrl'],
                      name: doctor['name'],
                      to: doctor['to'],
                      uid: doctor.id,
                    ),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) => Align(
                      child: SizeTransition(
                        sizeFactor: animation,
                        child: DrDetails(
                          about: doctor['about'],
                          departmnet: doctor['department'],
                          experiance: doctor['experiance'],
                          fees: doctor['fees'],
                          from: doctor['form'],
                          hospital: doctor['hospitalNAme'],
                          imageUrl: doctor['imageUrl'],
                          name: doctor['name'],
                          to: doctor['to'],
                          uid: doctor.id,
                        ),
                      ),
                    ),
                  ));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Image.network(
                          doctor['imageUrl'] ?? '',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        doctor['name'],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(doctor['department']),
                      trailing: BlocBuilder<FavoriteBloc, FavoriteState>(
                        bloc: favoriteBloc,
                        builder: (context, state) {
                          final isFavorite = state is FavoriteLoaded && state.favorites.contains(doctor.id);
                          return GestureDetector(
                            onTap: () {
                              favoriteBloc.add(ToggleFavoriteEvent(doctor.id, isFavorite));
                            },
                            child: Icon(
                              isFavorite ?   IconlyLight.heart:IconlyBold.heart,
                              color: isFavorite ?Colormanager.blueicon : Colormanager.blueicon,
                              size: 28,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
