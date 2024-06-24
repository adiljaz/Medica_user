import 'package:fire_login/blocs/auth/auth_bloc.dart';
import 'package:fire_login/screens/bottomnav/home.dart';
import 'package:fire_login/screens/introScreens/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    MediaQueryData mediaQuery = MediaQuery.of(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // TODO: implement listener

      if(state is Authenticated){
        Navigator.of(context).pushReplacement(MaterialPageRoute(  builder: (context)=> Bottomnav(), )); // home
      }else if( state is UnAuthenticated){
        // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>LoginPage() )); // login 
        Navigator.of(context).pushReplacement(PageTransition(child: WelcomeScreen(), type: PageTransitionType.fade));
      }



      },

      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.fill,
                  height: mediaQuery.size.height * 0.12,
                  width: mediaQuery.size.height * 0.12,
                ),
                Text(
                  'Medica',
                  style: GoogleFonts.signika(
                      textStyle:
                          const TextStyle(fontWeight: FontWeight.bold, fontSize: 35)),
                )
              ],
            ),
            const Spacer(),
            Lottie.asset('assets/lottie/loading.json',
                fit: BoxFit.cover,
                width: mediaQuery.size.height * 0.15,
                height: mediaQuery.size.height * 0.15)
          ],
        ),
      ),
    );
  }
}
