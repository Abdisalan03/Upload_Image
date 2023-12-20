
import 'package:fire_baseproject/UploadImage.dart';
import 'package:fire_baseproject/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  
  runApp(
     MaterialApp(
      debugShowCheckedModeBanner: false,
      home:   StreamFirebase(),
      theme: ThemeData(
        useMaterial3: false
      ),
    
    ),
  );
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
    