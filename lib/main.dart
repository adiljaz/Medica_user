import 'package:fire_login/blocs/auth/auth_bloc.dart';
import 'package:fire_login/blocs/bottomnav/landing_state_bloc.dart';
import 'package:fire_login/blocs/intro/nextpage_bloc.dart';
import 'package:fire_login/screens/splash/splash_view.dart';
import 'package:fire_login/blocs/Forgot/forgot_password_bloc.dart';
import 'package:fire_login/blocs/Google/google_auth_bloc.dart';
import 'package:fire_login/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';






void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget { 
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context)=>AuthBloc()..add(CheckLoginStatusEvent()),child: const SplashScreen(),),
        BlocProvider(  create: (context) => NextpageBloc(),),

        BlocProvider(
          create: (context) => GoogleAuthBloc(),
          child: Container(),
        ),
        BlocProvider(
          create: (context) => ForgotPasswordBloc(),
          child: Container(),
        ),
        BlocProvider(
          create: (context) => LandingStateBloc(),
          child: Container(),
        )
        
        
      ],

      child: MaterialApp(
      debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Colors.blueAccent),
        home : const SplashScreen(),
      
      ),
    );
  }
}