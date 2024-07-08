import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/status_controller/status_controller.dart';
import '../../data/Model/status_model.dart';
import '../../res/color/app_color.dart';
import '../../res/routes/routes_name.dart';
import '../../res/widget/loader.dart';

class StatusContactScreen extends StatelessWidget {
   StatusContactScreen({super.key});
  StatusController statusController = Get.put(StatusController());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Status>>(
      future: statusController.getStatus(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            var statusData = snapshot.data![index];
            return Column(
              children: [
                InkWell(
                  onTap: () {
                    Get.toNamed(RouteName.statusScreen, arguments: statusData);

                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ListTile(
                      title: Text(
                        statusData.username,
                      ),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          statusData.profilePic,
                        ),
                        radius: 30,
                      ),
                    ),
                  ),
                ),
                const Divider(color: AppColor.dividerColor, indent: 85),
              ],
            );
          },
        );
      },
    );
  }
}
