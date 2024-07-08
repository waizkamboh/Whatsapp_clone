

import 'dart:io';
// import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../res/color/app_color.dart';


  void toastMessage(String msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColor.tabColor,
        textColor: AppColor.blackColor,
        fontSize: 16.0
    );
  }


Future<File?>  pickImageFromGalley(BuildContext context) async{
  File? image;
  try{
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(pickedImage != null){
      image = File(pickedImage.path);
    }
  }catch (e){
    toastMessage(e.toString());

  }
  return image;


}

Future<File?> pickVideoFromGallery(BuildContext context) async {
  File? video;
  try {
    final pickedVideo =
    await ImagePicker().pickVideo(source: ImageSource.gallery);

    if (pickedVideo != null) {
      video = File(pickedVideo.path);
    }
  } catch (e) {
    toastMessage(e.toString());
  }
  return video;
}


// Future<GiphyGif?> pickGIF(BuildContext context) async {
//   GiphyGif? gif;
//   try {
//     gif = await Giphy.getGif(
//       context: context,
//       apiKey: 'Vz9X4SXYBPyKLD2pJm1fdWCpnoBtDSLE',
//     );
//   } catch (e) {
//     toastMessage(e.toString());
//   }
//   return gif;
// }