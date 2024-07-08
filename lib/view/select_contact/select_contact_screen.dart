import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:get/get.dart';
import '../../controller/select_contact_controller/select_contact_controller.dart';
import '../../res/widget/error.dart';
import '../../res/widget/loader.dart';



class SelectContactsScreen extends StatefulWidget {
  const SelectContactsScreen({super.key});

  @override
  State<SelectContactsScreen> createState() => _SelectContactsScreenState();
}

class _SelectContactsScreenState extends State<SelectContactsScreen> {
  final SelectContactController controller = Get.put(SelectContactController());
  bool _isSearchActive = false;
  final TextEditingController _searchController = TextEditingController();

  List<Contact> _filteredContacts = []; // List to store filtered contacts

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterContacts(String searchTerm) {
    if (searchTerm.isEmpty) {
      _filteredContacts.clear();
    } else {
      _filteredContacts = controller.contacts.where((contact) =>
          contact.displayName.toLowerCase().contains(searchTerm.toLowerCase())).toList();
    }
    setState(() {}); // Update UI with filtered contacts
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isSearchActive
          ? AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search contacts...',
            border: InputBorder.none,
          ),
          autofocus: true,
          onChanged: (value) => _filterContacts(value), // Call filter function on change
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => setState(() {
              _isSearchActive = false;
              _filteredContacts.clear(); // Clear filtered contacts list
            }),
          ),
        ],
      )
          : AppBar(
        title: const Text('Select contact'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => setState(() => _isSearchActive = true),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {}, // Implement your desired action for the overflow menu
          ),
        ],
      ),
      body: Obx(
            () {
          if (controller.isLoading.value) {
            return const Loader();
          }
          if (controller.contacts.isEmpty) {
            return const ErrorScreen(error: 'No contacts found.');
          }

          // Display filtered contacts if search is active and not empty, otherwise display all contacts
          final contactsToDisplay = _isSearchActive && _searchController.text.isNotEmpty
              ? _filteredContacts
              : controller.contacts;

          return ListView.builder(
            itemCount: contactsToDisplay.length,
            itemBuilder: (context, index) {
              final contact = contactsToDisplay[index];
              return InkWell(
                onTap: () => controller.selectContact(contact, context),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ListTile(
                    title: Text(
                      contact.displayName,
                      style: const TextStyle(fontSize: 18),
                    ),
                    leading: contact.photo == null ? null : CircleAvatar(
                      backgroundImage: MemoryImage(contact.photo!),
                      radius: 30,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}