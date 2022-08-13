import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:ml_kit/screens/camera_screen.dart';
import 'package:ml_kit/screens/splash_screen.dart';

// Global variable for storing the list of cameras available
List<CameraDescription> cameras = [];

Future<void> main() async {
  // Fetch the available cameras before initializing the app.
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    debugPrint('CameraError: ${e.description}');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(
        duration: 3,
        gotoPage: CameraScreen(),
      ),
    );
  }
}
