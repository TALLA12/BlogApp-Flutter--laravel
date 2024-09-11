import 'package:blog/AllScreens/home.dart';
import 'package:blog/AllScreens/register.dart';

import 'package:blog/models/api_response.dart';
import 'package:blog/models/user.dart';
import 'package:blog/services/user_service.dart';
import 'package:blog/utils/colors.dart';

import 'package:blog/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  static const String idScreen = "Login";
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailTextEditingController =
      TextEditingController();
  final TextEditingController passwordTextEditingController =
      TextEditingController();

  @override
  void dispose() {
    emailTextEditingController.dispose();
    passwordTextEditingController.dispose();
    super.dispose();
  }

  void _login(BuildContext context) async {
    ApiResponse response = await login(
      emailTextEditingController.text,
      passwordTextEditingController.text,
    );

    if (response.error == null) {
      _saveAndRedirectToHome(response.data as User);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  void _saveAndRedirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => Home()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 65.0,
              ),
              Image.asset(
                'images/logo2.jpg',
                width: 390.0,
                height: 250.0,
                alignment: Alignment.center,
              ),
              Divider(
                color: Colors.black,
                thickness: 2.0,
              ),
              SizedBox(
                height: 1.0,
              ),
              Text(
                "Bienvenue,",
                style: TextStyle(fontSize: 24.0),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 2,
              ),
              AppTextField(
                textController: emailTextEditingController,
                hintText: "Email",
                icon: Icons.email,
              ),
              SizedBox(
                height: 20,
              ),
              AppTextField(
                isObscure: true,
                textController: passwordTextEditingController,
                hintText: "Password",
                icon: Icons.password_sharp,
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  primary: AppColors.myBlueColor,
                  textStyle: TextStyle(
                    fontSize: 18.0,
                    fontFamily: "Brand Bold",
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        0), // 0 pour désactiver les coins arrondis
                  ),
                  minimumSize: Size(400, 50),
                ),
                onPressed: () {
                  if (!emailTextEditingController.text.contains("@")) {
                    displayToastMessage("Email address is not valid", context);
                  } else if (passwordTextEditingController.text.isEmpty) {
                    displayToastMessage("Password is mandatory", context);
                  } else {
                    _login(context);
                  }
                },
                child: Text("Login"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => Register()),
                    (Route<dynamic> route) => false,
                  );
                },
                child: Text(
                  "Do not have an Account? Register here.",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

void displayToastMessage(String message, BuildContext context) {
  Fluttertoast.showToast(msg: message);
}
