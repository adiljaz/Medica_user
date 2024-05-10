import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:meta/meta.dart';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

part 'add_user_event.dart';
part 'add_user_state.dart';

class AddUserBloc extends Bloc<AddUserEvent, AddUserState> {


   final  FirebaseAuth  _auth =FirebaseAuth.instance;


  AddUserBloc() : super(AddUserInitial()) {
    on<AddUserClick>((event, emit) async {
      emit(AddUserLOadingState());
  String? uid  =   _auth.currentUser?.uid ;

  
      final result = await _addData(
        name: event.name,
        age: event.age,
        dob: event.dob,
        gender: event.gender,
        imageUrl: event.imageUrl,
        location: event.location,
        mobile: event.mobile, uid: uid,
      );

      if (result) {
        emit(AddUserSuccesState());
      } else {
        emit(AddUserErrorState('Failed to add data.'));
      }
    });
  }


  Future<bool> _addData({
    required String name,
    required int age,
    required String? imageUrl,
    required int dob,
    required String gender,
    required String location,
    required String? uid,
    required int mobile,
  }) async {
    final CollectionReference userCollection =
        FirebaseFirestore.instance.collection('users');

      
      

    final Map<String, dynamic> userData = {
      'name': name,
      'age': age,
      'imageUrl': imageUrl,
      'dob': dob,
      'gender': gender,
      'location': location,
      'uid':uid,
      'mobile':mobile,
    };

    try {
      await userCollection.add(userData);
      print('Data added successfully!');
      return true; // Return true if data is added successfully
    } catch (error) {
      print('Error adding data: $error');
      return false; // Return false if an error occurs
    }
  }
  /////////////
}
