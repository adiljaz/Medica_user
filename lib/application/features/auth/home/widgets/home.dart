import 'package:fire_login/application/features/auth/auth_bloc/bloc/auth_bloc.dart';
import 'package:fire_login/application/features/auth/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [IconButton(onPressed: () {
      
      
                final authBloc =BlocProvider.of<AuthBloc>(context);
                authBloc.add(LogoutEvent());
      
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder:(context)=>LoginPage() ), (route) => false);
      
      
          }, icon: Icon(Icons.logout))],
        ),
        body: Column(
          children: [Text('Home page')],
        ),
      ),
    );
  }
}
