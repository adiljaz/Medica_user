import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:fire_login/blocs/Favorite/favorite_bloc.dart';
import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:fire_login/screens/home/drdetails/details.dart';

class AllDoctorsHorizontal extends StatefulWidget {
  const AllDoctorsHorizontal({Key? key}) : super(key: key);

  @override
  _AllDoctorsState createState() => _AllDoctorsState();
}

class _AllDoctorsState extends State<AllDoctorsHorizontal> {
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
      body: StreamBuilder(
        stream: doctorCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
                child: Text('Something went wrong: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No doctors available'));
          }

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doctor = snapshot.data!.docs[index];

              return Padding(
                padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          DrDetails(
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
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) =>
                              Align(
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
                    height: mediaQuery.size.height * 0.02,
                    width: mediaQuery.size.width*0.45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colormanager.whiteContainer,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
                          child: Container(
                            height: mediaQuery.size.height * 0.18,
                            width: mediaQuery.size.width * 0.5 ,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.network(
                                doctor['imageUrl'] ?? '',
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                            
                          child: Text(
                            doctor['name'],
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: Center(
                            child: Text(
                              overflow: TextOverflow.ellipsis,
                              doctor['department'],
                              style: GoogleFonts.poppins(
                                fontSize: 11 ,
                                fontWeight: FontWeight.w500,
                                color: Colormanager.grayText,
                              ),
                            ),
                          ),
                        ),

                       Container(
                        
                        height: mediaQuery.size.height*0.045,
                        width: mediaQuery.size.width*0.3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colormanager.blueicon),child: Center(child: Text('Book',style: GoogleFonts.poppins(fontWeight: FontWeight.w600,color: Colormanager.whiteText),)),)

                      ],
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
