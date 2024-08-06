import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_login/blocs/auth/auth_bloc.dart';
import 'package:fire_login/screens/authentication/login/login_view.dart';
import 'package:fire_login/screens/profile/addrofile.dart';
import 'package:fire_login/screens/profile/editprofile.dart';
import 'package:fire_login/screens/profile/privacypolicy/pricacypoicy.dart';
import 'package:fire_login/screens/profile/terms/terms.dart';
import 'package:fire_login/theme/theme.dart';
import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:fire_login/widgets/profile/profilerow.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatelessWidget {
  Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    final user = FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: _auth.currentUser!.uid);

    MediaQueryData mediaquery = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colormanager.scaffold,
        body: StreamBuilder<QuerySnapshot>(
          stream: user.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.data!.docs.isEmpty) {
              print('hrelloooooooooooooooooo');
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: mediaquery.size.height * 0.02,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.cover,
                          height: 50,
                          width: 90,
                        ),
                        SizedBox(
                          width: mediaquery.size.width * 0.15,
                        ),
                        Text(
                          'Profile',
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20)),
                        )
                      ],
                    ),
                    Stack(
                      children: [
                        Image.asset(
                          'assets/images/profileno.png',
                          height: mediaquery.size.height * 0.25,
                          width: mediaquery.size.width * 0.5,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                            top: 120,
                            left: 145,
                            child: Icon(
                              Icons.add_to_photos,
                              size: 40,
                            ))
                      ],
                    ),

                    Text(
                      'add name ',
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 17)),
                    ),
                    Text(
                      'add phone number ',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: mediaquery.size.height * 0.02,
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Divider(),
                    ),
                    SizedBox(
                      height: mediaquery.size.height * 0.03,
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AddProfile()));
                      },
                      child: ProfileOptions(
                        leadingIcon: Icons.account_circle,
                        typetext: 'add profile',
                        trialingIcon: Icon(Icons.navigate_next),
                      ),
                    ),

                    SizedBox(
                      height: mediaquery.size.height * 0.015,
                    ),
                    
               
                    ProfileOptions(
                        leadingIcon: Icons.groups,
                        typetext: 'Invite friends',
                        trialingIcon: Icon(Icons.navigate_next)),
                    SizedBox(
                      height: mediaquery.size.height * 0.015,
                    ),
                    GestureDetector(
                      onTap: () =>_launchEmail(), 
                      child: ProfileOptions(
                          leadingIcon: Icons.email,
                          typetext: 'Feed Back',
                          trialingIcon: Icon(Icons.navigate_next)),
                    ),
                    SizedBox(
                      height: mediaquery.size.height * 0.015,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(PageTransition(
                            child: PrivacyPolicyPage(),
                            type: PageTransitionType.fade)); 
                      },
                      child: ProfileOptions(
                          leadingIcon: Icons.security,
                          typetext: 'Privacy Policy',
                          trialingIcon: Icon(Icons.navigate_next)),
                    ),
                    SizedBox(
                      height: mediaquery.size.height * 0.015,
                    ),
               
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(PageTransition(child: TermsAndConditionsPage(), type: PageTransitionType.fade));

                      },
                      child: ProfileOptions(
                        leadingIcon: Icons.local_police,
                        typetext: 'Terms and conditions',
                         trialingIcon: Icon(Icons.navigate_next), 
                      ),
                    ),
                           SizedBox(
                      height: mediaquery.size.height * 0.015,
                    ), 
                    GestureDetector(
                      onTap: () {
                        showLogoutDialog(context);
                      },
                      child: ProfileOptions(
                          leadingIcon: IconlyLight.logout,
                          typetext: 'Logout ',
                          trialingIcon: Icon(Icons.navigate_next)),
                    ), 
                  ],
                ),
              );
            }

            if (snapshot.hasData) {
              var userData = snapshot.data!.docs.first;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: mediaquery.size.height * 0.02,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.cover,
                          height: 50,
                          width: 90,
                        ),
                        SizedBox(
                          width: mediaquery.size.width * 0.15,
                        ),
                        Text(
                          'Profile',
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20)),
                        )
                      ],
                    ),
                    Stack(
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => EditProfile(
                                        age: userData['age'],
                                        dob: userData['dob'],
                                        gender: userData['gender'],
                                        image: userData['imageUrl'],
                                        location: userData['location'],
                                        name: userData['name'],
                                        uid: userData.id,
                                        mobile: userData['mobile'],
                                      )));
                            },
                            child: Container(
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(200),
                                    child: userData['imageUrl'] != null
                                        ? Image.network(
                                            userData['imageUrl'],
                                            height:
                                                mediaquery.size.height * 0.25,
                                            width: mediaquery.size.width * 0.55,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.asset(
                                            'assets/images/dr 5.jpg')))),
                        Positioned(
                            top: 120,
                            left: 145,
                            child: Icon(
                              Icons.add_to_photos,
                              size: 40,
                            ))
                      ],
                    ),
                    Text(
                      userData['name'] != null ? userData['name'] : 'add name ',
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 17)),
                    ), 
                    Text(
                      userData['mobile'] != null
                          ? userData['mobile'].toString()
                          : 'add phone number',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: mediaquery.size.height * 0.02,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Divider(),
                    ),
                    SizedBox(
                      height: mediaquery.size.height * 0.03,
                    ),
                    GestureDetector(
                      onTap: () { 
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => EditProfile(
                                  age: userData['age'],
                                  dob: userData['dob'],
                                  gender: userData['gender'], 
                                  image: userData['imageUrl'],
                                  location: userData['location'],
                                  name: userData['name'],
                                  uid: userData.id,
                                  mobile: userData['mobile'],
                                )));
                      },
                      child: ProfileOptions(
                          leadingIcon: Icons.account_circle,
                          typetext: 'EditProfile',
                          trialingIcon: Icon(
                            Icons.navigate_next,
                          )),
                    ),
                  
                    SizedBox(
                      height: mediaquery.size.height * 0.015,
                    ),
                    ProfileOptions(
                        leadingIcon: Icons.groups,
                        typetext: 'Invite friends',
                        trialingIcon: Icon(Icons.navigate_next)),
                    SizedBox(
                      height: mediaquery.size.height * 0.015,
                    ),
                    GestureDetector(
                      onTap: () =>_launchEmail(), 
                      child: ProfileOptions(
                          leadingIcon: Icons.email,
                          typetext: 'Feed Back',
                          trialingIcon: Icon(Icons.navigate_next)),
                    ),
                    SizedBox(
                      height: mediaquery.size.height * 0.015,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(PageTransition(
                            child: PrivacyPolicyPage(),
                            type: PageTransitionType.fade)); 
                      },
                      child: ProfileOptions(
                          leadingIcon: Icons.security,
                          typetext: 'Privacy Policy',
                          trialingIcon: Icon(Icons.navigate_next)),
                    ),
                    SizedBox(
                      height: mediaquery.size.height * 0.015,
                    ),
               
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(PageTransition(child: TermsAndConditionsPage(), type: PageTransitionType.fade));

                      },
                      child: ProfileOptions(
                        leadingIcon: Icons.local_police,
                        typetext: 'Terms and conditions',
                         trialingIcon: Icon(Icons.navigate_next), 
                      ),
                    ),
                           SizedBox(
                      height: mediaquery.size.height * 0.015,
                    ), 
                    GestureDetector(
                      onTap: () {
                        showLogoutDialog(context);
                      },
                      child: ProfileOptions(
                          leadingIcon: IconlyLight.logout,
                          typetext: 'Logout ',
                          trialingIcon: Icon(Icons.navigate_next)),
                    ),

                   SizedBox(  height: mediaquery.size.height * 0.04,), 

                  Text('version 0.01')
                  ],
                ),
              );
            }

            return SizedBox();
          },
        ),
      ),
    );
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.blueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Text(
            "Confirm Sign Out",
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            "Are you sure you want to sign out?",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                "Sign Out",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                final authBloc = BlocProvider.of<AuthBloc>(context);
                authBloc.add(LogoutEvent());

                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (route) => false);
              },
            ),
          ],
        );
      },
    );
  }
  

 Future<void> _launchEmail() async { 
  final Email email = Email(
    body: '',
    subject: '',
    recipients: ['adiljaz17@gmail.com'],
    isHTML: false,
  );

  try {
    await FlutterEmailSender.send(email);
  } catch (error) {
    print('Error sending email: $error');
    // You might want to show an error dialog to the user here
  }
} 


String? encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}
}   