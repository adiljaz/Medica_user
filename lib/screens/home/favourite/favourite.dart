import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_login/blocs/Favorite/favorite_bloc.dart';
import 'package:fire_login/screens/home/drdetails/details.dart';
import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';

class Favourite extends StatelessWidget {
  const Favourite({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FavoriteBloc favoriteBloc = BlocProvider.of<FavoriteBloc>(context);
    final doctorCollection = FirebaseFirestore.instance.collection('doctor');

    // Trigger the event to load favorites when the widget is built
    favoriteBloc.add(LoadFavoritesEvent());

    return Scaffold(
      backgroundColor: Colormanager.scaffold,
      appBar: AppBar(
        title: Text("Favorite Doctors"),
      ),
      body: BlocBuilder<FavoriteBloc, FavoriteState>(
        bloc: favoriteBloc,
        builder: (context, state) {
          if (state is FavoriteLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is FavoriteError) {
            return Center(child: Text('Something went wrong: ${state.message}'));
          }

          if (state is FavoriteLoaded) {
            if (state.favorites.isEmpty) {
              return Center(child: Text('No favorite doctors available'));
            }

            return StreamBuilder(
              stream: doctorCollection.where(FieldPath.documentId, whereIn: state.favorites).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Something went wrong: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No favorite doctors available'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final doctor = snapshot.data!.docs[index];

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => DrDetails(
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
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colormanager.whiteContainer,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.network(
                                      doctor['imageUrl'] ?? '',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        doctor['name'],
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 19,
                                        ),
                                      ),
                                      Text(
                                        doctor['department'],
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Colormanager.grayText,
                                        ),
                                      ),
                                      Text(
                                        doctor['hospitalNAme'],
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Colormanager.grayText,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '4.3 (3,837 reviews)',
                                            style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color: Colormanager.grayText,
                                            ),
                                          ),
                                          BlocBuilder<FavoriteBloc, FavoriteState>(
                                            bloc: favoriteBloc,
                                            builder: (context, state) {
                                              if (state is FavoriteLoaded) {
                                                final isFavorite = state.favorites.contains(doctor.id);
                                                return IconButton(
                                                  icon: Icon(
                                                    isFavorite ? IconlyBold.heart : IconlyLight.heart,
                                                    color: isFavorite ? Colormanager.blueicon : null,
                                                    size: 28,
                                                  ),
                                                  onPressed: () {
                                                    favoriteBloc.add(
                                                      ToggleFavoriteEvent(doctor.id, isFavorite),
                                                    );
                                                  },
                                                );
                                              }
                                              return Icon(
                                                IconlyLight.heart,
                                                size: 28,
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }

          return Container();
        },
      ),
    );
  }
}
  