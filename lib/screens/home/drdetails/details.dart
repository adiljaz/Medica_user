import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_login/blocs/Favorite/favorite_bloc.dart';
import 'package:fire_login/screens/home/booking/booking.dart';
import 'package:fire_login/screens/message/chat.dart';
import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:fire_login/widgets/drdetail/round.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';


class DrDetails extends StatefulWidget {
  final String imageUrl;
  final int experiance;
  final String about;
  final String from;
  final String to;
  final String name;
  final String departmnet;
  final String hospital;
  final int fees;
  final String? uid;

  const DrDetails({
    super.key,
    required this.imageUrl,
    required this.experiance,
    required this.about,
    required this.from,
    required this.to,
    required this.name,
    required this.departmnet,
    required this.hospital,
    required this.fees,
    this.uid,
  });

  @override
  State<DrDetails> createState() => _DrDetailsState();
}

class _DrDetailsState extends State<DrDetails> {
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
    final FavoriteBloc favoriteBloc = BlocProvider.of<FavoriteBloc>(context);
    MediaQueryData mediaQuery = MediaQuery.of(context);

    return SafeArea(
      child: BlocProvider(
        create: (context) => FavoriteBloc(),
        child: BlocBuilder<FavoriteBloc, FavoriteState>(
          bloc: favoriteBloc,
          builder: (context, state) {
               if (state is FavoriteLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is FavoriteError) {
            return Center(child: Text('Something went wrong: ${state.message}'));
          }
          if (state is FavoriteLoaded) {

            return Scaffold(
              backgroundColor: Colormanager.scaffold,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                leading: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.arrow_back_ios)),
                title: Text(
                  widget.name,
                  style: GoogleFonts.dongle(
                      textStyle:
                          TextStyle(fontSize: 33, fontWeight: FontWeight.w600)),
                ),
                centerTitle: true,
                actions: [
                  BlocBuilder<FavoriteBloc, FavoriteState>(
                    builder: (context, state) {
                      bool isFavorite = false;
                      if (state is FavoriteLoaded &&
                          state.favorites.contains(widget.uid)) {
                        isFavorite = true;
                      }

                      return GestureDetector(
                        onTap: () {
                          favoriteBloc.add(
                              ToggleFavoriteEvent(widget.uid!, isFavorite));
                        },
                        child: BlocBuilder<FavoriteBloc, FavoriteState>(
                                            bloc: favoriteBloc,
                                            buildWhen: (previous, current) {
                                              if (current is FavoriteLoaded) {
                                                return previous is! FavoriteLoaded || previous.favorites != current.favorites;
                                              }
                                              return false;
                                            },
                                            builder: (context, state) {
                                              if (state is FavoriteLoaded) {
                                                final isFavorite = state.favorites.contains(widget.uid);
                                                return GestureDetector(
                                                  onTap: () {
                                                    favoriteBloc.add(
                                                      ToggleFavoriteEvent(widget.uid!, isFavorite),
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
                      );
                    },
                  )
                ],
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: mediaQuery.size.height * 0.02,
                    ),
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colormanager.whiteContainer,
                            borderRadius: BorderRadius.circular(10)),
                        height: mediaQuery.size.height * 0.16,
                        width: mediaQuery.size.width * 0.9,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.network(
                                      widget.imageUrl,
                                      height: mediaQuery.size.height * 0.13,
                                      width: mediaQuery.size.width * 0.28,
                                      fit: BoxFit.cover,
                                    )),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    widget.name,
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20)),
                                  ),
                                  SizedBox(
                                      width: mediaQuery.size.width * 0.47,
                                      child: Divider()),
                                  Text(
                                    widget.departmnet,
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13)),
                                  ),
                                  Text(
                                    widget.hospital,
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13)),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: mediaQuery.size.height * 0.02,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25, right: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  DetailsRound(
                                    icon: Icon(
                                      Icons.groups,
                                      size: 30,
                                      color: Colormanager.blueicon,
                                    ),
                                  ),
                                  Text('5,000+',
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        textStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colormanager.blueText),
                                      )),
                                  Text(
                                    'Patients',
                                    style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  DetailsRound(
                                    icon: Icon(
                                      Icons.workspace_premium,
                                      size: 26,
                                      color: Colormanager.blueicon,
                                    ),
                                  ),
                                  Text(widget.experiance.toString(),
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        textStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colormanager.blueText),
                                      )),
                                  Text(
                                    'Experiance',
                                    style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  DetailsRound(
                                    icon: Icon(
                                      IconlyBold.star,
                                      size: 26,
                                      color: Colormanager.blueicon,
                                    ),
                                  ),
                                  Text('4.8',
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        textStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colormanager.blueText),
                                      )),
                                  Text(
                                    'Rating',
                                    style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  DetailsRound(
                                    icon: Icon(
                                      Icons.sms,
                                      size: 26,
                                      color: Colormanager.blueicon,
                                    ),
                                  ),
                                  Text('4,942+',
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        textStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colormanager.blueText),
                                      )),
                                  Text(
                                    'Review',
                                    style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: mediaQuery.size.height * 0.01,
                          ),
                          SizedBox(
                            height: 35,
                            child: Text('About',
                                style: GoogleFonts.dongle(
                                  textStyle: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )),
                          ),
                          Text(
                              maxLines: 4,
                              widget.about,
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colormanager.grayText),
                              )),
                          SizedBox(
                            height: mediaQuery.size.height * 0.05,
                            child: Text(
                              'Working Time',
                              style: GoogleFonts.dongle(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30)),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                widget.from,
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "  -  ",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                widget.to,
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          SizedBox(
                              height: mediaQuery.size.height * 0.05,
                              child: Text(
                                'Consultation fees',
                                style: GoogleFonts.dongle(
                                    fontWeight: FontWeight.bold, fontSize: 30),
                              )),
                          Text(
                            " Rs${widget.fees.toString()}",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                color: Colormanager.blueText),
                          ),
                          Text(
                            'Reviews',
                            style: GoogleFonts.dongle(
                                fontWeight: FontWeight.bold, fontSize: 33),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: Container(
                decoration: BoxDecoration(
                    color: Colormanager.whiteContainer,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40),
                        topLeft: Radius.circular(40))),
                height: mediaQuery.size.height * 0.123,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(PageTransition(
                            child: ChatPage(
                              receiveUserId: widget.uid!,
                              image: widget.imageUrl,
                              name: widget.name,
                            ),
                            type: PageTransitionType.fade));
                      },
                      child: Container(
                        child: Center(
                            child: Text(
                          'Send message',
                          style: GoogleFonts.dongle(
                              fontWeight: FontWeight.w500,
                              fontSize: 25,
                              color: Colormanager.blueText),
                        )),
                        height: mediaQuery.size.height * 0.06,
                        width: mediaQuery.size.width * 0.38,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colormanager.lightblue,
                        ),
                      ),
                    ),
                    Container(
                      child: Center(
                          child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(PageTransition(
                            child: Booking(
                                image: widget.imageUrl,
                                fromTime: widget.from,
                                toTime: widget.to,
                                uid: widget.uid.toString(),
                                fees: widget.fees),
                            type: PageTransitionType.fade,
                          ));
                        },
                        child: Text(
                          'Book Aoointment',
                          style: GoogleFonts.dongle(
                              fontWeight: FontWeight.w500,
                              fontSize: 25,
                              color: Colormanager.whiteText),
                        ),
                      )),
                      height: mediaQuery.size.height * 0.06,
                      width: mediaQuery.size.width * 0.5,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colormanager.blueContainer),
                    ),
                  ],
                ),
              ),
            );
          } 

          return Container(); 
          },
        ),
      ),
    );
  }
}
