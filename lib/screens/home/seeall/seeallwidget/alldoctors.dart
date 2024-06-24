import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:fire_login/blocs/Favorite/favorite_bloc.dart';
import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:fire_login/screens/home/drdetails/details.dart';

class AllDoctors extends StatefulWidget {
  const AllDoctors({Key? key}) : super(key: key);

  @override
  _AllDoctorsState createState() => _AllDoctorsState();
}

class _AllDoctorsState extends State<AllDoctors> {
  late FavoriteBloc favoriteBloc;
  late FirebaseAuth _auth;
  late CollectionReference doctorCollection;

  @override
  void initState() {
    super.initState();
    favoriteBloc = BlocProvider.of<FavoriteBloc>(context);
    _auth = FirebaseAuth.instance;
    doctorCollection = FirebaseFirestore.instance.collection('doctor');
    favoriteBloc.add(LoadFavoritesEvent());
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: Colormanager.scaffold,
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
            return StreamBuilder(
              stream: doctorCollection.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Something went wrong: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No doctors available'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final doctor = snapshot.data!.docs[index];

                    return Padding(
                      padding: const EdgeInsets.only(left: 13, top: 13, right: 13),
                      child: GestureDetector(
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
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colormanager.whiteContainer,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10, top: 15),
                                child: Container(
                                  height: mediaQuery.size.height * 0.145,
                                  width: mediaQuery.size.width * 0.3,
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
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: mediaQuery.size.width * 0.45,
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 15),
                                              child: Text(
                                                doctor['name'],
                                                overflow: TextOverflow.fade,
                                                maxLines: 1,
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 19,
                                                ),
                                              ),
                                            ),
                                          ),
                                          BlocBuilder<FavoriteBloc, FavoriteState>(
                                            bloc: favoriteBloc,
                                            buildWhen: (previous, current) {
                                              if (current is FavoriteLoaded) {
                                                return previous is! FavoriteLoaded || previous.favorites != current.favorites;
                                              }
                                              return false;
                                            },
                                            builder: (context, state) {
                                              if (state is FavoriteLoaded) {
                                                final isFavorite = state.favorites.contains(doctor.id);
                                                return GestureDetector(
                                                  onTap: () {
                                                    favoriteBloc.add(
                                                      ToggleFavoriteEvent(doctor.id, isFavorite),
                                                    );
                                                  },
                                                  child: Icon(
                                                    isFavorite ? IconlyBold.heart : IconlyLight.heart,
                                                    color: isFavorite ? Colormanager.blueicon : null,
                                                    size: 28,
                                                  ),
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
                                      SizedBox(width: mediaQuery.size.width * 0.5, child: Divider()),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: 100,
                                            child: Text(
                                              doctor['department'],
                                              style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: Colormanager.grayText,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '|',
                                            style: TextStyle(
                                              color: Colormanager.grayText,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 100,
                                            child: Text(
                                              doctor['hospitalNAme'],
                                              style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: Colormanager.grayText,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            IconlyBold.star,
                                            color: Colormanager.blueicon,
                                          ),
                                          Spacer(),
                                          Text(
                                            '4.3',
                                            style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color: Colormanager.grayText,
                                            ),
                                          ),
                                          Spacer(),
                                          Text(
                                            '(3,837 reviews)',
                                            style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color: Colormanager.grayText,
                                            ),
                                          ),
                                          SizedBox(width: mediaQuery.size.width * 0.1)
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ), 
                            ],
                          ),
                          height: mediaQuery.size.height * 0.18,
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
