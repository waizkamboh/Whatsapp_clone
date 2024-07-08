import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_app/data/Model/user_model.dart';
import '../../../controller/chat_controller/chat_controller.dart';
import '../../../data/Model/chat_contact.dart';
import '../../../res/color/app_color.dart';
import '../../../res/routes/routes_name.dart';
import '../../../res/widget/loader.dart';



class ContactsList extends StatelessWidget {
   ContactsList({Key? key}) : super(key: key);
  ChatController chatController = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: StreamBuilder<List<ChatContact>>(
        stream: chatController.chatContacts(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Loader();
          }
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No contacts available.'));
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var chatContactsData = snapshot.data![index];
              return Column(
                children: [
                  InkWell(
                    onTap: () {

                      Get.toNamed(RouteName.mobileChatScreen, arguments: UserModel());


                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ListTile(
                        title: Text(
                          chatContactsData.name,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Text(
                            chatContactsData.lastMessage,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            chatContactsData.profilePic,
                          ),
                          radius: 30,
                        ),
                        trailing: Text(
                          DateFormat.Hm().format(chatContactsData.timeSent),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Divider(color: AppColor.dividerColor, ),
                  ),
                ],
              );
            },
          );
        }
      ),
    );
  }
}