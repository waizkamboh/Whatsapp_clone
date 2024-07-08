import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';

import '../../data/repository/select_contact_repository/select_contact_repository.dart';

class SelectContactController extends GetxController {
  final SelectContactRepository selectContactRepository = SelectContactRepository();

  var contacts = <Contact>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    getContacts();
  }

  Future<void> getContacts() async {
    try {
      isLoading(true);
      contacts.value = await selectContactRepository.getContacts();
    } finally {
      isLoading(false);
    }
  }

  void selectContact(Contact selectedContact, BuildContext context) {
    selectContactRepository.selectContact(selectedContact, context);
  }
}
