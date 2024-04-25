import 'package:firebase_auth/firebase_auth.dart';

class Data {
  Data._();
  // Get current user id
  static String get currentUserId => FirebaseAuth.instance.currentUser!.uid;
}
