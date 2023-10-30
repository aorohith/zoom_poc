// import 'dart:async';
// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zooom_poc/native_poc_module.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   var zoom;
//   _incrementCounter() async {
//     // _launchUrl();
//     // joinMeeting(context);
//     // var status = await Permission.camera.request();
//     // var micStatus = await Permission.microphone.request();
//     // if (status.isDenied) {
//     //   // We didn't ask for permission yet or the permission has been denied before, but not permanently.
//     // }
//     // InitConfig initConfig = InitConfig(
//     //   domain: "zoom.us",
//     //   enableLog: true,
//     // );
//     // zoom = ZoomVideoSdk();
//     // var eventListener = ZoomVideoSdkEventListener();
//     // joinSession();
//     // controller.runJavaScript('''
//     //         console.log('Requesting camera and microphone permissions...');
//     //         navigator.mediaDevices.getUserMedia({ video: true })
//     //           .then(function (stream) {
//     //             // Permission granted, you can start using the camera and microphone
//     //           })
//     //           .catch(function (error) {
//     //             console.error('Error accessing camera/microphone:',error);
//     //           });
//     //       ''');
//   }

//   joinSession() async {
//     Map<String, bool> SDKaudioOptions = {"connect": true, "mute": true};
//     Map<String, bool> SDKvideoOptions = {
//       "localVideoOn": true,
//     };
//     // JoinSessionConfig joinSession = JoinSessionConfig(
//     //   sessionName: "sessionName",
//     //   sessionPassword: "sessionPwd",
//     //   token: "JWT token",
//     //   userName: "displayName",
//     //   audioOptions: SDKaudioOptions,
//     //   videoOptions: SDKvideoOptions,
//     //   sessionIdleTimeoutMins: 10,
//     // );
//     // await zoom.joinSession(joinSession);
//   }

//   // Future<void> _launchUrl() async {
//   //   final Uri _url = Uri.parse(
//   //       'https://us05web.zoom.us/j/86834163559?pwd=aOi9JMZ0RiU0VFJwbJaUKg8rC8JpH7.1');

//   //   if (!await launchUrl(
//   //     _url,
//   //     mode: LaunchMode.inAppWebView,
//   //   )) {
//   //     throw Exception('Could not launch $_url');
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
//       body: const HomePage(),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
