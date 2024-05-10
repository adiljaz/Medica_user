import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_login/blocs/auth/auth_bloc.dart';
import 'package:fire_login/screens/authentication/login/login_view.dart';
import 'package:fire_login/screens/profile/editprofile.dart';
import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:fire_login/widgets/profile/profilerow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';

class Profile extends StatelessWidget {
   Profile({super.key});

  final CollectionReference user = FirebaseFirestore.instance.collection('users');  

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaquery = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colormanager.scaffold,
        body: StreamBuilder<QuerySnapshot>(stream:user.snapshots() , builder: (context, snapshot) {
          if(snapshot.hasData){
             var userData = snapshot.data!.docs.first;
          return   SingleChildScrollView(
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
                        textStyle:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  )
                ],
              ),
              Stack(
                children: [
                  Container(  child: ClipRRect(   borderRadius: BorderRadius.circular(100),  child: Image.network(userData['imageUrl'], fit: BoxFit.cover,width: mediaquery.size.width*0.57, height: mediaquery.size.height*0.25,  ))),
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

                userData['name'],
                
                style: GoogleFonts.poppins(
                    textStyle:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
              ),
              Text(
                userData['mobile'].toString(), 
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
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>EditProfile(age:userData['age'] ,dob:userData['dob'] ,gender:userData['gender'] ,image:userData['imageUrl'] ,location: userData['location'],name:userData['name'] ,uid:userData.id,mobile: userData['mobile'],) )); 
                  
                },
                child: ProfileOptions(
                  leadingIcon: Icons.account_circle,
                  typetext: 'EditProfile',
                  trialingIcon: Icons.navigate_next,
                ),
              ),
          
              SizedBox(
                height: mediaquery.size.height * 0.015,
              ),
              ProfileOptions(
                  leadingIcon: Icons.visibility,
                  typetext: 'Dark Mode',
                  trialingIcon: Icons.navigate_next),
              SizedBox(
                height: mediaquery.size.height * 0.015,
              ),
              ProfileOptions(
                  leadingIcon: Icons.groups,
                  typetext: 'Ivite friends',
                  trialingIcon: Icons.navigate_next),
              SizedBox(
                height: mediaquery.size.height * 0.015,
              ),
              ProfileOptions(
                  leadingIcon: Icons.email,
                  typetext: 'Feed Back',
                  trialingIcon: Icons.navigate_next),
              SizedBox(
                height: mediaquery.size.height * 0.015,
              ),
              ProfileOptions(
                  leadingIcon: Icons.security,
                  typetext: 'Privacy Policy',
                  trialingIcon: Icons.navigate_next),
              SizedBox(
                height: mediaquery.size.height * 0.015,
              ),
              GestureDetector(
                onTap: (){
                   final authBloc = BlocProvider.of<AuthBloc>(context);
                      authBloc.add(LogoutEvent());

                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => LoginPage()),
                          (route) => false);
                  
                },
                child: ProfileOptions(
                    leadingIcon: IconlyLight.logout,
                    typetext: 'Logout ',
                    trialingIcon: Icons.navigate_next),
              ),
            ],
          ),
        );
          }

          return SizedBox();
        }
        
        ,),
      ),
    );
  }
}