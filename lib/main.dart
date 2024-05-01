import 'package:fire_login/application/features/auth/auth_bloc/bloc/auth_bloc.dart';
import 'package:fire_login/application/features/auth/introScreens/bloc/nextpage_bloc.dart';
import 'package:fire_login/application/features/auth/splash/splash_view.dart';
import 'package:fire_login/application/features/auth/views/Googlebloc/google_auth_bloc.dart';
import 'package:fire_login/application/features/auth/views/Googlebloc/repo.dart';
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