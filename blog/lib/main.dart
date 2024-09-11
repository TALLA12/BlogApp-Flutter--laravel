import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AllScreens/home.dart';
import 'AllScreens/login.dart';
import 'AllScreens/register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  runApp(MyApp(initialRoute: token != null ? '/home' : '/login'));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.initialRoute}) : super(key: key);

  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: initialRoute,
      routes: {
        '/home': (context) => Home(),
        '/login': (context) => Login(),
        '/register': (context) => Register(),
      },
    );
  }
}
