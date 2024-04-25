import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quiz_app/firebase_options.dart';
import 'package:quiz_app/layout.dart';
import 'package:quiz_app/pages/quiz/home_page.dart';
import 'package:quiz_app/repositories/authentication_repository.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:quiz_app/utils/constants/colors.dart';

Future<void> main() async {
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then(
    (FirebaseApp value) => Get.put(AuthenticationRepository()),
  );

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize GetStorage
  await GetStorage.init();

  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: MyColors.primary),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(
            color: MyColors.primary, // Warna tanda panah kembali
          ),
        ),
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.blue[900],
          ),
        ),
      ),
      routes: {
        '/layout': (context) => const Layout(),
      }, // Menggunakan SplashScreen sebagai home
    );
  }
}
