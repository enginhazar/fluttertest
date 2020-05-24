import 'package:firebasetest/core/helper/shared_manager.dart';
import 'package:firebasetest/ui/view/authentication/login_view.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedManager.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Material App', home: LoginView());
  }
}
