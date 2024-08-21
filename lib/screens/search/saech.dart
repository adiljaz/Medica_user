import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_login/screens/home/drdetails/details.dart';
import 'package:fire_login/screens/message/gemini.dart';
import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

class SearchPage extends StatefulWidget {
  SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> _searchResults = [];

  void _searchDoctors(String query) async {
    if (query.isNotEmpty) {
      var doctors = await FirebaseFirestore.instance
          .collection('doctor')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: query + '\uf8ff')
          .get();

      setState(() {
        _searchResults = doctors.docs;
      });
    } else {
      setState(() {
        _searchResults = [];
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colormanager.scaffold,
          title: Text(
            'Search ',
            style: GoogleFonts.dongle(
              fontWeight: FontWeight.bold,
              fontSize: 33,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
        ),
        backgroundColor: Colormanager.scaffold,
        body: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Column(
            children: [
              SearchField(
                icon: IconlyLight.search,
                controller: _searchController,
                onChanged: (value) {
                  _searchDoctors(value);
                },
              ),
              Expanded(
                child: _searchResults.isEmpty
                    ? Center(
                        child: Text(
                          _searchController.text.isNotEmpty
                              ? 'No search results'
                              : '',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final doctor = _searchResults[index];
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 13, top: 13, right: 13),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
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
                                    transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) =>
                                        Align(
                                      child: SizeTransition(
                                        sizeFactor: animation,
                                        child: child,
                                      ),
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
                                      padding: const EdgeInsets.only(
                                          left: 10, top: 15),
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.145,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.46,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 15),
                                                    child: SizedBox(
                                                      width: 100,
                                                      child: Text(
                                                        doctor['name'],
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 19,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Spacer(),
                                                Icon(
                                                  IconlyBold.heart,
                                                  color: Colormanager.blueicon,
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.05,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.5,
                                              child: Divider(),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                SizedBox(
                                                  width: 100,
                                                  child: Center(
                                                    child: Text(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      doctor['department'],
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 13,
                                                        textStyle: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colormanager
                                                              .grayText,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  '|',
                                                  style: TextStyle(
                                                    color:
                                                        Colormanager.grayText,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 100,
                                                  child: Center(
                                                    child: Text(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      doctor['hospitalNAme'],
                                                      style:
                                                          GoogleFonts.poppins(
                                                        textStyle: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colormanager
                                                              .grayText,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                DoctorRatingWidget(doctorId: doctor.id),
                                                Spacer(),
                                                StreamBuilder<QuerySnapshot>(
                                                  stream: FirebaseFirestore.instance
                                                      .collection('doctor')
                                                      .doc(doctor.id)
                                                      .collection('reviews')
                                                      .snapshots(),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                                      return CircularProgressIndicator();
                                                    }
                                                    if (snapshot.hasError) {
                                                      return Text('Error: ${snapshot.error}');
                                                    }
                                                    final reviewCount = snapshot.data?.docs.length ?? 0;
                                                    return Text(
                                                      '($reviewCount reviews)',
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colormanager.grayText,
                                                      ),
                                                    );
                                                  },
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.1,
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
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  final IconData icon;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const SearchField({
    Key? key,
    required this.icon,
    required this.controller,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          fillColor: Colormanager.whiteContainer,
          filled: true,
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10)),
          prefixIcon: Icon(icon),
          hintText: 'Search doctors...',
          suffixIcon: GestureDetector(
            onTap: () {
              Navigator.of(context).push(PageTransition(
                  child: GeminiAi(), type: PageTransitionType.fade));
            },
            child: Container(
              width: 30,
              height: 30,
              child: Transform.scale(
                scale: 0.8,
                child: Lottie.asset('assets/lottie/ai.json'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DoctorRatingWidget extends StatelessWidget {
  final String doctorId;

  const DoctorRatingWidget({Key? key, required this.doctorId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('doctor')
          .doc(doctorId)
          .collection('reviews')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final reviews = snapshot.data?.docs ?? [];
        double averageRating = 0;
        if (reviews.isNotEmpty) {
          double totalRating = reviews.fold(0, (sum, review) => sum + (review['rating'] as num));
          averageRating = totalRating / reviews.length;
        }

        return Row(
          children: [
            Icon(
              IconlyBold.star,
              color: Colormanager.blueicon,
              size: 20,
            ),
            SizedBox(width: 4),
            Text(
              averageRating.toStringAsFixed(1),
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colormanager.grayText,
              ),
            ),
          ],
        );
      }, 
    );
  }
}