import 'package:get/get.dart'; // Import GetX package
import 'package:connectivity_plus/connectivity_plus.dart'; // Import connectivity_plus package
import 'package:sample_project/network_controller.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> checkConnectivity() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      print('Connected to the internet');
    } else {
      print('No internet connection');
    }
  }
}
