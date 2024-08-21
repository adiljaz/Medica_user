import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:fire_login/blocs/Favorite/favorite_bloc.dart';
import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:fire_login/screens/home/drdetails/details.dart';
import 'package:shimmer/shimmer.dart';

class AllDoctors extends StatefulWidget {
  const AllDoctors({Key? key}) : super(key: key);

  @override
  _AllDoctorsState createState() => _AllDoctorsState();
}

class _AllDoctorsState extends State<AllDoctors> {
  late FavoriteBloc favoriteBloc;
  // ignore: unused_field
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

  Future<Map<String, dynamic>> _getDoctorRatingAndReviews(String doctorId) async {
    QuerySnapshot reviewsSnapshot = await FirebaseFirestore.instance
        .collection('doctor')
        .doc(doctorId)
        .collection('reviews')
        .get();

    int reviewCount = reviewsSnapshot.docs.length;
    double totalRating = 0;

    for (var doc in reviewsSnapshot.docs) {
      totalRating += (doc['rating'] as num).toDouble();
    }

    double averageRating = reviewCount > 0 ? totalRating / reviewCount : 0;

    return {
      'reviewCount': reviewCount,
      'averageRating': averageRating,
    };
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
            return _buildShimmerEffect(mediaQuery);
          }

          if (state is FavoriteError) {
            return Center(child: Text('Something went wrong: ${state.message}'));
          }

          if (state is FavoriteLoaded) {
            return StreamBuilder(
              stream: doctorCollection.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildShimmerEffect(mediaQuery);
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
                              experiance: doctor['experiance'],
                              fees: doctor['fees'],
                              from: doctor['form'],
                              hospital: doctor['hospitalNAme'],
                              imageUrl: doctor['imageUrl'],
                              name: doctor['name'],
                              to: doctor['to'],
                              uid: doctor.id,
                            ),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) => Align(
                              child: SizeTransition(
                                sizeFactor: animation,
                                child: child,
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
                                            child: Center(
                                              child: Text(
                                                overflow: TextOverflow.ellipsis,
                                                doctor['department'],
                                                style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colormanager.grayText,
                                                ),
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
                                            child: Center(
                                              child: Text(
                                                overflow: TextOverflow.ellipsis,
                                                doctor['hospitalNAme'],
                                                style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colormanager.grayText,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      FutureBuilder<Map<String, dynamic>>(
                                        future: _getDoctorRatingAndReviews(doctor.id),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return _buildRatingShimmer();
                                          }
                                          if (snapshot.hasError || !snapshot.hasData) {
                                            return Text('Error loading rating');
                                          }
                                          final data = snapshot.data!;
                                          return Row(
                                            children: [
                                               SizedBox(width:mediaQuery.size.width*0.03), 
                                              Icon(
                                                IconlyBold.star,
                                                color: Colormanager.blueicon,
                                              ),
                                              SizedBox(width:mediaQuery.size.width*0.02), 
                                              Text(
                                                data['averageRating'].toStringAsFixed(1),
                                                style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colormanager.grayText,
                                                ),
                                              ),
                                             SizedBox(width:mediaQuery.size.width*0.02),  
                                              Text(
                                                '(${data['reviewCount']} reviews)',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colormanager.grayText,
                                                ),
                                              ),
                                              SizedBox(width: mediaQuery.size.width * 0.1)
                                            ],
                                          );
                                        },
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

  Widget _buildShimmerEffect(MediaQueryData mediaQuery) {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(13),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: mediaQuery.size.height * 0.18,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRatingShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Row(
        children: [
          Container(width: 24, height: 24, color: Colors.white),
          Spacer(),
          Container(width: 30, height: 16, color: Colors.white),
          Spacer(),
          Container(width: 100, height: 16, color: Colors.white),
        ],
      ),
    );
  }
} 