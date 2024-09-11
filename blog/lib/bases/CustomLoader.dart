import 'package:blog/AllScreens/home.dart';
import 'package:blog/AllScreens/login.dart';
import 'package:blog/models/api_response.dart';
import 'package:blog/services/user_service.dart';
import 'package:blog/utils/app_constants.dart';
import 'package:blog/utils/colors.dart';
import 'package:blog/utils/dimensions.dart';
import 'package:flutter/material.dart';

class CustomLoader extends StatelessWidget {
  const CustomLoader({Key? key});

  Future<void> _loadUserInfo(BuildContext context) async {
    String token = await getToken();
    if (token == '') {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Login()),
        (Route<dynamic> route) => false,
      );
    } else {
      ApiResponse response = await getUserDetail();
      if (response.error == null) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Home()),
          (Route<dynamic> route) => false,
        );
      } else if (response.error == AppConstants.unauthorized) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Login()),
          (Route<dynamic> route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${response.error}'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _loadUserInfo(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // You can add more UI elements or customize the loading indicator
          return Center(
            child: Container(
              height: Dimensions.height20 * 5,
              width: Dimensions.height20 * 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.height20 * 5 / 2),
                color: AppColors.mainColor,
              ),
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          );
        } else {
          // Return a placeholder or loading indicator while the future is still running
          return CircularProgressIndicator();
        }
      },
    );
  }
}
