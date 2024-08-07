import 'package:fire_login/blocs/Favorite/favorite_bloc.dart';
import 'package:fire_login/blocs/Obascure/obscure_bloc.dart';
import 'package:fire_login/blocs/auth/auth_bloc.dart';
import 'package:fire_login/blocs/calendar/bloc/calendar_bloc.dart';
import 'package:fire_login/blocs/dateofbirth/bloc/date_of_birth_bloc.dart';
import 'package:fire_login/blocs/drcount/doctor_details_bloc.dart';

import 'package:fire_login/blocs/edit_user/edit_user_bloc.dart';
import 'package:fire_login/blocs/bottomnav/landing_state_bloc.dart';
import 'package:fire_login/blocs/gender/bloc/gender_bloc.dart';
import 'package:fire_login/blocs/intro/nextpage_bloc.dart';
import 'package:fire_login/blocs/location/location_bloc.dart';
import 'package:fire_login/blocs/news/news_bloc.dart';
import 'package:fire_login/blocs/news/news_event.dart';
import 'package:fire_login/blocs/profile/AddUser/add_user_bloc.dart';
import 'package:fire_login/blocs/profile/Delete/delete_bloc.dart';
import 'package:fire_login/blocs/profile/ImageAdding/image_adding_bloc.dart';
import 'package:fire_login/blocs/profile/ImageUrl/image_url_bloc.dart';
import 'package:fire_login/blocs/savedoctor/savedoctor_bloc.dart';
import 'package:fire_login/blocs/saveuser/bloc/saveuser_bloc.dart';
import 'package:fire_login/blocs/search/bloc/search_bloc.dart';
import 'package:fire_login/screens/message/const.dart';
import 'package:fire_login/screens/news/repository/repository.dart';
import 'package:fire_login/screens/splash/splash_view.dart';
import 'package:fire_login/blocs/Forgot/forgot_password_bloc.dart';
import 'package:fire_login/blocs/Google/google_auth_bloc.dart';
import 'package:fire_login/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

void main() async {
    Gemini.init(apiKey: GEMINI_API_KEY); 

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
     final NewsaRepository newsaRepository = NewsaRepository();
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
        ),
        BlocProvider(
          create: (context) => SaveDoctorBloc(),
          child: Container(),
        ),
       BlocProvider(
          create: (context) => NewsBloc(newsaRepository: newsaRepository)..add(StartEvent()),
        child: Container(),
       ),

       BlocProvider(
        create: (context) => LocationBlocBloc(),
        child: Container(), 
       ),
       BlocProvider(
        create: (context) => DateOfBirthBloc(),
        child: Container(),
       ),
       BlocProvider(
        create: (context) => GenderBloc(), 
        child: Container(),
       ),
       BlocProvider(
        create: (context) => PatientCountBloc(),
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
