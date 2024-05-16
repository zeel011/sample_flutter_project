import 'package:get/get.dart';
import 'package:sample_project/network_controller.dart';

class DependencyInjection {
  static void init(){
    Get.put<NetworkController>(NetworkController(),permanent: true);
  }
}
