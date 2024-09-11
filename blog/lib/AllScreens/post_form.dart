import 'dart:io';

import 'package:blog/AllScreens/login.dart';
import 'package:blog/models/api_response.dart';
import 'package:blog/models/post.dart';
import 'package:blog/services/post_service.dart';
import 'package:blog/services/user_service.dart';
import 'package:blog/utils/app_constants.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PostForm extends StatefulWidget {
  final Post? post;
  final String? title;
  const PostForm({super.key, this.post, this.title});

  @override
  State<PostForm> createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _textControllerBody = TextEditingController();
  bool _loading = false;
  File? _imageFile;
  final _picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _create(BuildContext context) async {
    try {
      setState(() {
        _loading = true;
      });

      String? image = _imageFile == null ? null : getStringImage(_imageFile);
      ApiResponse response = await createPosts(_textControllerBody.text, image);

      if (response.error == null) {
        Navigator.of(context).pop();
      } else if (response.error == AppConstants.unauthorized) {
        await logout();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Login()),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${response.error}')),
        );
      }
    } catch (e) {
      // Handle any exceptions that might occur during the process
      print('Error: $e');
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void _editPost(int postId) async {
    ApiResponse response = await editPost(postId, _textControllerBody.text);
    if (response.error == null) {
      Navigator.of(context).pop();
    } else if (response.error == AppConstants.unauthorized) {
      await logout();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Login()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${response.error}')),
      );
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    if (widget.post != null) {
      _textControllerBody.text = widget.post!.body ?? '';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('${widget.title}'),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                widget.post != null
                    ? SizedBox()
                    : Container(
                        height: 200,
                        decoration: BoxDecoration(
                            image: _imageFile == null
                                ? null
                                : DecorationImage(
                                    image: FileImage(_imageFile ?? File('')),
                                    fit: BoxFit.cover)),
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: IconButton(
                            icon: Icon(
                              Icons.image,
                              color: Colors.black38,
                            ),
                            onPressed: () {
                              getImage();
                            },
                          ),
                        ),
                      ),
                Form(
                  key: _formkey,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: TextFormField(
                      controller: _textControllerBody,
                      keyboardType: TextInputType.multiline,
                      maxLines: 9,
                      validator: (val) =>
                          val!.isEmpty ? 'Post body is required' : null,
                      decoration: InputDecoration(
                        hintText: "Ecrire un post...",
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.black38)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      primary: Colors.deepPurple,
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
                      if (_formkey.currentState!.validate()) {
                        if (widget.post == null) {
                          _create(context);
                        } else {
                          _editPost(widget.post!.id ?? 0);
                        }
                        // Pass the context here
                      }
                    },
                    child: Text("Publier"),
                  ),
                )
              ],
            ),
    );
  }
}
