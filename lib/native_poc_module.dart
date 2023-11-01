import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zoom_native_sdk/zoom_native_sdk.dart';
import 'package:zooom_poc/components/custom_snackbar.dart';
import 'package:zooom_poc/utils/constants.dart';
import 'package:zooom_poc/zoom_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isPermissionGranted = false;
  final _zoomNativelyPlugin = ZoomNativeSdk();
  bool isInitialized = false;

  final ZoomController controller = Get.put(ZoomController());

  String browserUrl =
      "https://zoom.us/j/91804939335?pwd=eWloaThZSDB1WTVrWCtZbW01cG91dz09";

  @override
  void initState() {
    initPlatformState();
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.

    try {
      if (!isInitialized) {
        isInitialized = (await _zoomNativelyPlugin.initZoom(
              appKey:
                  controller.clientIdController.text, //uO9W5xDKTUavDQEALxeLA
              appSecret: controller.clientSecretIdController
                  .text, //rB5CeAStldfZHxrO2jO4QE56r8TYTHn8
            )) ??
            false;
      }
    } on PlatformException catch (e) {
      debugPrint(e.message);
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  getPermission() async {
    await Permission.camera.request();
    await Permission.microphone.request();
    isPermissionGranted = await Permission.camera.status.isGranted &&
        await Permission.microphone.status.isGranted;
  }

  String? validateURL(String? value) {
    try {
      final uri = Uri.tryParse(value ?? "");

      // Check if the URL is valid
      if (uri == null ||
          !uri.scheme.startsWith('https') ||
          !uri.host.contains('zoom.us')) {
        return "Invalid URL";
      }

      // Extract the path segments
      final pathSegments = uri.pathSegments;

      // Ensure that the path is not empty and contains at least two segments
      if (pathSegments.length < 2) {
        return "Meeting ID and password are required";
      }

      // The last two segments in the path should be the meeting ID and password
      final meetingId = pathSegments.last;
      // Manually parse the query string
      final queryParameters = uri.queryParameters;

      // Extract the meeting ID and password, handling nullable values

      final password = queryParameters['pwd'];

      // You can further validate the extracted meeting ID and password as needed
      if (meetingId.isEmpty || (password?.isEmpty ?? false)) {
        return "Meeting ID and password cannot be empty";
      }

      final result = _getMeetIdPass(value ?? "");
      if (result.isEmpty || result.length != 2) {
        return "There is some issue with the url";
      }

      return null;
    } catch (e) {
      return "There is some issue with the url";
    }
  }

  final TextEditingController _urlController =
      TextEditingController(text: Constants.meetUrl);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              "assets/app_icon.png",
              height: 50,
            ),
            const SizedBox(width: 10),
            const Text("Zoom with Flutter"),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () async {
              await Get.dialog(
                AlertDialog(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Enter Details'),
                      TextButton(
                          onPressed: () {
                            controller.clearTextField();
                          },
                          child: const Text("Reset"))
                    ],
                  ),
                  content: Form(
                    child: GetBuilder<ZoomController>(
                      id: ZoomController.rebuildTextField,
                      builder: (_) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              controller: controller.clientIdController,
                              decoration:
                                  const InputDecoration(labelText: 'Client ID'),
                              maxLines: 1,
                            ),
                            TextFormField(
                              controller: controller.clientSecretIdController,
                              decoration: const InputDecoration(
                                  labelText: 'Client Secret ID'),
                              maxLines: 2,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        controller.clearTextField();
                        Get.back();
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        // Handle submit action
                        //if the id changed
                        if (controller.clientIdController.text !=
                                Constants.clientId ||
                            controller.clientSecretIdController.text !=
                                Constants.clientSecretId) {
                          isInitialized = false;
                          await initPlatformState();
                        }
                        Get.back();
                      },
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    controller: _urlController,
                    maxLines: 2,
                    keyboardType: TextInputType.url,
                    validator: validateURL,
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      labelText: "Enter Url",
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: const BorderSide(
                          color: Colors.blue,
                          width: 1.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: const BorderSide(
                          color: Colors.blue,
                          width: 1.0,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: const BorderSide(
                          color: Colors
                              .blue, // Customize the border color for error state.
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: const BorderSide(
                          color: Colors
                              .blue, // Customize the border color for error state.
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: sdkOnPressed,
                  child: const Text("Join Meeting"),
                ),
                const SizedBox(
                  height: 20,
                ),
              ]),
        ),
      ),
    );
  }

  Future<void> sdkOnPressed() async {
    String meetingId = "";
    String meetingPassword = "";
    if (_urlController.text.isNotEmpty) {
      if (!_formKey.currentState!.validate()) {
        return;
      }
      List<String> idAndPass = _getMeetIdPass(_urlController.text);
      if (idAndPass.isNotEmpty) {
        meetingId = idAndPass.first;
        meetingPassword = idAndPass.last;
      } else {
        getSnackbar("The url having some issue");
        return;
      }
    } else {
      _urlController.text = Constants.meetUrl;
      setState(() {});
      List<String> result = _getMeetIdPass(Constants.meetUrl);
      if (result.isNotEmpty) {
        meetingId = result.first;
        meetingPassword = result.last;
      } else {
        getSnackbar("The url having some issue");
        return;
      }
    }

    bool status = await getAllPermission();
    if (status) {
      // debugPrint("joinMeting -> isInitialized = $isInitialized");
      if (isInitialized) {
        await _zoomNativelyPlugin.joinMeting(
          meetingNumber: meetingId,
          meetingPassword: meetingPassword,
        );
      }
    }
  }

  Future<bool> getAllPermission() async {
    if (!isPermissionGranted) {
      await getPermission();
    }
    if (await Permission.camera.isPermanentlyDenied ||
        await Permission.microphone.isPermanentlyDenied) {
      openAppSettings();
    }
    if (isPermissionGranted) {
      return true;
    } else {
      return false;
    }
  }
}

List<String> _getMeetIdPass(String inputUrl) {
  try {
    // Parse the URL
    Uri uri = Uri.parse(inputUrl);

    // Extract the meeting ID from the path
    String meetingId = uri.pathSegments.last;

    // Extract the password from the query parameters
    String? password = uri.queryParameters['pwd'];

    // Check if both meeting ID and password are present
    if (meetingId.isNotEmpty && password != null && password.isNotEmpty) {
      // Remove any trailing .1 or similar numeric suffix
      String cleanedPassword =
          RegExp(r'(.*?)(\.\d+)?$').firstMatch(password)?.group(1) ?? "";

      if (cleanedPassword.isNotEmpty) {
        return [meetingId, cleanedPassword];
      }
    }
  } catch (e) {
    // Handle exception if needed
  }

  // Return an empty list if extraction fails
  return [];
}
