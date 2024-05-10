import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'delete_event.dart';
part 'delete_state.dart';

class DeleteBloc extends Bloc<DeleteEvent, DeleteState> {
  DeleteBloc() : super(DeleteInitial()) {
    on<DeleteClick>((event, emit) async {
      final result = await _deleteDocument(
        event.id,
      );

      if (result) {
        emit(DeleteDoneState());
      } else {
        emit(DeleteErrorState());
      }
    });
  }

  _deleteDocument(String documentId) async {
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(documentId)
          .delete()
          .then((value) {});

      print('Document deleted successfully!');
    } catch (e) {
      print('Error deleting document: $e');
    }
  }
}
