import 'package:blog/AllScreens/login.dart';
import 'package:blog/models/api_response.dart';
import 'package:blog/services/comment_service.dart';
import 'package:blog/services/user_service.dart';
import 'package:blog/utils/app_constants.dart';
import 'package:blog/widgets/app_text_field.dart';

import 'package:flutter/material.dart';
import 'package:blog/models/comment.dart';

class CommentScreen extends StatefulWidget {
  final int? postId;

  const CommentScreen({super.key, this.postId});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  TextEditingController _txtCommentController = TextEditingController();
  List<dynamic> _commentsList = [];
  bool _loading = true;
  int userId = 0;
  int _editCommentId = 0;
  Future<void> _getComments() async {
    userId = await getUserid();
    ApiResponse response = await getComments(widget.postId ?? 0);
    if (response.error == null) {
      setState(() {
        _commentsList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
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

  void _createComment() async {
    ApiResponse response =
        await createComment(widget.postId ?? 0, _txtCommentController.text);
    if (response.error == null) {
      _txtCommentController.clear();
      _getComments();
    } else if (response.error == AppConstants.unauthorized) {
      await logout();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Login()),
        (route) => false,
      );
    } else {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${response.error}'),
        ),
      );
    }
  }

  void _deleteComment(int commentId) async {
    ApiResponse response = await deleteComment(commentId);
    if (response.error == null) {
      _getComments();
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

  void _editComment() async {
    ApiResponse response =
        await editComment(_editCommentId, _txtCommentController.text);
    if (response.error == null) {
      _editCommentId = 0;
      _txtCommentController.clear();
      _getComments();
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
    _getComments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Text('Comments'),
        ),
        body: _loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Expanded(
                      child: RefreshIndicator(
                    onRefresh: () {
                      return _getComments();
                    },
                    child: ListView.builder(
                      itemCount: _commentsList.length,
                      itemBuilder: (BuildContext context, int index) {
                        Comment comment = _commentsList[index];
                        return Container(
                          padding: EdgeInsets.all(20),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.black26, width: 0.5))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          image: comment.user!.image != null
                                              ? DecorationImage(
                                                  image: NetworkImage(
                                                      '${comment.user!.image}'),
                                                  fit: BoxFit.cover)
                                              : null,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.blueGrey,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        '${comment.user!.name}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16),
                                      )
                                    ],
                                  ),
                                  comment.user!.id == userId
                                      ? PopupMenuButton(
                                          child: Padding(
                                            padding: EdgeInsets.only(right: 10),
                                            child: Icon(
                                              Icons.more_vert,
                                              color: Colors.black,
                                            ),
                                          ),
                                          itemBuilder: (context) => [
                                            PopupMenuItem(
                                              child: Text('Edit'),
                                              value: 'edit',
                                            ),
                                            PopupMenuItem(
                                              child: Text('Delete'),
                                              value: 'delete',
                                            )
                                          ],
                                          onSelected: (val) {
                                            if (val == 'edit') {
                                              setState(() {
                                                _editCommentId =
                                                    comment.id ?? 0;
                                                _txtCommentController.text =
                                                    comment.comment ?? '';
                                              });
                                            } else {
                                              _deleteComment(comment.id ?? 0);
                                            }
                                          },
                                        )
                                      : SizedBox()
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text('${comment.comment}')
                            ],
                          ),
                        );
                      },
                    ),
                  )),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border(
                      top: BorderSide(color: Colors.black26, width: 0.5),
                    )),
                    child: Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            textController: _txtCommentController,
                            hintText: 'Ecrire un commentaire',
                            icon: Icons.sms,
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              if (_txtCommentController.text.isNotEmpty) {
                                setState(() {
                                  _loading = true;
                                });
                                if (_editCommentId > 0) {
                                  _editComment();
                                } else {
                                  _createComment();
                                }
                              }
                            },
                            icon: Icon(Icons.send)),
                      ],
                    ),
                  )
                ],
              ));
  }
}
