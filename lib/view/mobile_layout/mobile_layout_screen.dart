import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/auth/auth_controller.dart';
import '../../res/color/app_color.dart';
import '../../res/routes/routes_name.dart';
import '../../res/size_config/size_config.dart';
import '../../utils/utils.dart';
import '../chat/widget/contacts_list.dart';
import '../status/status_contact_screen.dart';



class MobileLayoutScreen extends StatefulWidget {
  const MobileLayoutScreen({super.key});

  @override
  State<MobileLayoutScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends State<MobileLayoutScreen> with WidgetsBindingObserver , TickerProviderStateMixin {
  AuthController authController = Get.put(AuthController());
  late TabController tabBarController;

  @override
  void initState() {
    super.initState();
    tabBarController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch(state){
      case AppLifecycleState.resumed:
        authController.setUserState(true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        authController.setUserState(false);
        break;

    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColor.appBarColor,
          centerTitle: false,
          title:  Text(
            'WhatsApp',
            style: TextStyle(
              fontSize: getFont(20),
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.grey),
              onPressed: () {

              },
            ),
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.grey),
              onPressed: () {
              },
            ),
          ],
          bottom:  TabBar(
            controller: tabBarController,
            indicatorColor: AppColor.tabColor,
            indicatorWeight: 4,
            labelColor: AppColor.tabColor,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            tabs: const [
              Tab(
                text: 'CHATS',
              ),
              Tab(
                text: 'STATUS',
              ),
              Tab(
                text: 'CALLS',
              ),
            ],
          ),
        ),
        body:  TabBarView(
          controller: tabBarController,
          children: [
            ContactsList(),
            StatusContactScreen(),
            const Text('Calls'),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async{
            if(tabBarController.index == 0){
              Get.toNamed(RouteName.selectContactScreen);

            }else{
              File? pickedImage = await pickImageFromGalley(context);
              if(pickedImage != null){
                Get.toNamed(RouteName.confirmStatusScreen, arguments: pickedImage);
              }
            }
          },
          backgroundColor: AppColor.tabColor,
          child: const Icon(
            Icons.comment,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
