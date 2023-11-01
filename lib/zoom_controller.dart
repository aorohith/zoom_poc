import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zooom_poc/utils/constants.dart';

class ZoomController extends GetxController {
  static const String rebuildTextField = "rebuildTextField";

  TextEditingController clientIdController =
      TextEditingController(text: Constants.clientId);
  TextEditingController clientSecretIdController =
      TextEditingController(text: Constants.clientSecretId);

  void clearTextField() {
    clientIdController.text = Constants.clientId;
    clientSecretIdController.text = Constants.clientSecretId;
    update([rebuildTextField]);
  }
}
