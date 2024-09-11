import 'dart:io';

import 'package:blog/AllScreens/login.dart';
import 'package:blog/models/api_response.dart';
import 'package:blog/models/user.dart';
import 'package:blog/services/user_service.dart';
import 'package:blog/utils/app_constants.dart';
import 'package:blog/utils/colors.dart';
import 'package:blog/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? user;
  bool loading = true;
  File? _imageFile;
  final _picker = ImagePicker();
  TextEditingController txtNameController = TextEditingController();

  Future getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void getUser() async {
    ApiResponse response = await getUserDetail();
    if (response.error == null) {
      setState(() {
        user = response.data as User;
        loading = false;
        txtNameController.text = user!.name ?? '';
      });
    } else if (response.error == AppConstants.unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => Login()),
              (route) => false,
            )
          });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${response.error}'),
        ),
      );
    }
  }

  void updateProfile() async {
    ApiResponse response =
        await updateUser(txtNameController.text, getStringImage(_imageFile));
    setState(() {
      loading = false;
    });
    if (response.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${response.error}'),
        ),
      );
    } else if (response.error == AppConstants.unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => Login()),
              (route) => false,
            )
          });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${response.error}'),
        ),
      );
    }
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Padding(
            padding: EdgeInsets.only(top: 40, left: 40, right: 40),
            child: ListView(
              children: [
                Center(
                  child: GestureDetector(
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          image: _imageFile == null
                              ? user!.image != null
                                  ? DecorationImage(
                                      image: NetworkImage('${user!.image}'),
                                      fit: BoxFit.cover)
                                  : null
                              : DecorationImage(
                                  image: FileImage(_imageFile ?? File('')),
                                  fit: BoxFit.cover),
                          color: Colors.amber),
                    ),
                    onTap: () {
                      getImage();
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                AppTextField(
                    textController: txtNameController,
                    hintText: "votre nom",
                    icon: Icons.person),
                SizedBox(
                  height: 20,
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
                    if (txtNameController.text.isEmpty) {
                      displayToastMessage("Veuillez entrer votre nom", context);
                    } else {
                      updateProfile();
                      displayToastMessage(
                          "Votre profil a ete mis a jour", context);
                    }
                  },
                  child: Text("Update"),
                ),
              ],
            ),
          );
  }
}
