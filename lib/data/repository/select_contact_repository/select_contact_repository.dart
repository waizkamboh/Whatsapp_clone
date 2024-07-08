import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import '../../../res/routes/routes_name.dart';
import '../../../utils/utils.dart';
import '../../Model/user_model.dart';

class SelectContactRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true,withPhoto: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }

  void selectContact(Contact selectedContact, BuildContext context) async {
    try {
      var userCollection = await firestore.collection('users').get();
      bool isFound = false;

      for (var document in userCollection.docs) {
        var userData = UserModel.fromMap(document.data());
        String selectedPhoneNum = selectedContact.phones[0].number.replaceAll(' ', '');
        if (selectedPhoneNum == userData.phoneNumber) {
          isFound = true;
          Get.toNamed(RouteName.mobileChatScreen,arguments: {
            'name' : userData.name,
            'uid' : userData.uid,
          }
          );
          break;
        }
      }

      if (!isFound) {
        toastMessage('This number does not exist on this app.');
      }
    } catch (e) {
      toastMessage(e.toString());
    }
  }
}
