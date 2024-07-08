import 'package:country_picker/country_picker.dart';
import 'package:get/get.dart';

class CountryController extends GetxController{
  final Rx<Country?> country = Rx(null);
  void pickCountry(){
    showCountryPicker(
        context: Get.context!,
        onSelect: (Country _country){
          country.value = _country;
        }
    );
  }
}