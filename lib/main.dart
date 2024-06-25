import 'package:fire_login/blocs/Favorite/favorite_bloc.dart';
import 'package:fire_login/blocs/Obascure/obscure_bloc.dart';
import 'package:fire_login/blocs/auth/auth_bloc.dart';
import 'package:fire_login/blocs/calendar/bloc/calendar_bloc.dart';
import 'package:fire_login/blocs/department/bloc/department_bloc.dart';
import 'package:fire_login/blocs/edit_user/edit_user_bloc.dart';
import 'package:fire_login/blocs/bottomnav/landing_state_bloc.dart';
import 'package:fire_login/blocs/intro/nextpage_bloc.dart';
import 'package:fire_login/blocs/profile/AddUser/add_user_bloc.dart';
import 'package:fire_login/blocs/profile/Delete/delete_bloc.dart';
import 'package:fire_login/blocs/profile/ImageAdding/image_adding_bloc.dart';
import 'package:fire_login/blocs/profile/ImageUrl/image_url_bloc.dart';
import 'package:fire_login/blocs/saveuser/bloc/saveuser_bloc.dart';
import 'package:fire_login/blocs/search/bloc/search_bloc.dart';
import 'package:fire_login/screens/splash/splash_view.dart';
import 'package:fire_login/blocs/Forgot/forgot_password_bloc.dart';
import 'package:fire_login/blocs/Google/google_auth_bloc.dart';
import 'package:fire_login/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc()..add(CheckLoginStatusEvent()),
          child: const SplashScreen(),
        ),
        BlocProvider(
          create: (context) => NextpageBloc(),
        ),
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
        ),
        BlocProvider(
          create: (context) => AddUserBloc(),
          child: Container(),
        ),
        BlocProvider(
          create: (context) => ImageAddingBloc(),
          child: Container(),
        ),
        BlocProvider(
          create: (context) => ImageUrlBloc(),
          child: Container(),

        ),
        BlocProvider(
          create: (context) => DeleteBloc(),
          child: Container(),
        ),
        BlocProvider(
          create: (context) => EditUserBloc(),
          child: Container(),
        ),
        BlocProvider(
          create: (context) => ObscureBloc(),
          child: Container(),
        ), 
        BlocProvider(
          create: (context) => GenderBloc(), 
          child: Container(),
        ),
      BlocProvider(
        create: (context) => CalendarBloc(),
        child: Container(),
      ),
      BlocProvider(
        create: (context) => SearchBloc(),
        child: Container(),
      ),
      BlocProvider(
        create: (context) => FavoriteBloc(), 
        child: Container(),
      ),
      BlocProvider(
        create: (context) => SaveUserBloc(),
        child: Container(),
      )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Colors.blueAccent),
        home: const SplashScreen(),
      ),
    );
  }
}


