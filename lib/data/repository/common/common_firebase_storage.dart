import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class CommonFirebaseStorageRepository {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String> storeFileToFirebase(String ref, File file) async {
    UploadTask uploadTask = _firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }
}
