import 'dart:typed_data';


import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

Future<String?> uploadImage(Uint8List imageData, String fileName) async {
  try {
    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref('users').child(fileName);  //// user
    final metadata =
        firebase_storage.SettableMetadata(contentType: 'images/jpeg');
    await ref.putData(imageData, metadata);

    String downloadURL = await ref.getDownloadURL();
    return downloadURL;
  } catch (e) {
    return null;
  }
}

//edit

// Future<void> editStudentClicked(documentid, data) async {
//   final CollectionReference user =
//       FirebaseFirestore.instance.collection('users');
//   try {
//     await user.doc(documentid).update(data);

//     print('successsssssssssssssssssss');
//   } catch (e) {
//     print(e);
//   }
// }
///// image storage conecting to firebase users

/// edit
