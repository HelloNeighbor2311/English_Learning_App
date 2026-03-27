import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

import '../firebase_options.dart';

class FirebaseBootstrap {
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
