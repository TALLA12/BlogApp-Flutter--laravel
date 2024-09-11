import 'package:blog/AllScreens/home.dart';
import 'package:blog/AllScreens/login.dart';

import 'package:blog/models/api_response.dart';
import 'package:blog/models/user.dart';
import 'package:blog/services/user_service.dart';
import 'package:blog/utils/colors.dart';

import 'package:blog/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  static const String idScreen = "Register";
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpasswordController =
      TextEditingController();

  void _register(BuildContext context) async {
    ApiResponse response = await register(
      nameController.text,
      emailController.text,
      passwordController.text,
      confirmpasswordController.text,
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
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmpasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: UniqueKey(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40.0,
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
                height: 2.0,
              ),
              Text(
                "S'inscrire",
                style: TextStyle(fontSize: 24.0, fontFamily: "Brand Bold"),
                textAlign: TextAlign.center,
              ),
              AppTextField(
                textController: nameController,
                hintText: "Name",
                icon: Icons.person,
              ),
              SizedBox(
                height: 20,
              ),
              AppTextField(
                textController: emailController,
                hintText: "Email",
                icon: Icons.email,
              ),
              SizedBox(
                height: 20,
              ),
              AppTextField(
                textController: passwordController,
                hintText: "Password",
                icon: Icons.password_sharp,
              ),
              SizedBox(
                height: 20,
              ),
              AppTextField(
                textController: confirmpasswordController,
                hintText: "Confirm password",
                icon: Icons.password_sharp,
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  primary: AppColors.myBlueColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  textStyle: TextStyle(
                    fontSize: 18.0,
                    fontFamily: "Brand Bold",
                  ),
                  minimumSize: Size(400, 50),
                ),
                onPressed: () {
                  if (nameController.text.length < 3) {
                    displayToastMessage(
                        "name must be at least 3 characters", context);
                  } else if (!emailController.text.contains("@")) {
                    displayToastMessage("Email address is not valid", context);
                  } else if (passwordController.text.length < 6) {
                    displayToastMessage(
                        "Password must be at least 6 characters", context);
                  } else {
                    _register(context);
                  }
                },
                child: Text("Create Account"),
              ),
              TextButton(
                onPressed: () {
                  Get.to(Login());
                },
                child: Text(
                  "Already have an Account? Login here.",
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
