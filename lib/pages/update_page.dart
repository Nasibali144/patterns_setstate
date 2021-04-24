import 'package:flutter/material.dart';
import 'package:patterns_setstate/models/post_model.dart';
import 'package:patterns_setstate/services/http_service.dart';

class UpdatePage extends StatefulWidget {

  static final String id = "update_page";
  final Post post;

  UpdatePage({this.post});

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  bool isLoading = false;
  var titleController = TextEditingController();
  var bodyController = TextEditingController();
  Post oldPost;

  _getOldPost() {
    setState(() {
      oldPost = widget.post;
      titleController.text = oldPost.title;
      bodyController.text = oldPost.body;
    });
  }

  _apiCreatePost() async{
    setState(() {
      isLoading = true;
    });

    String title = titleController.text.trim().toString();
    String body = bodyController.text.trim().toString();
    Post post = Post(title: title, body: body, userId: oldPost.userId, id: oldPost.id);

    var response = await Network.PUT(Network.API_UPDATE + oldPost.id.toString(), Network.paramsUpdate(post));
    print(response);
    setState(() {
      isLoading = false;
      if(response != null) {
        Navigator.pop(context, response);
      } else {
        print("Error");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getOldPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update post'),
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: "Post Title",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.only(right: 15, left: 15),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: bodyController,
                  decoration: InputDecoration(
                    labelText: "Post Body",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.only(
                        right: 15, top: 15, bottom: 50, left: 15),
                  ),
                  maxLines: 7,
                ),
                SizedBox(height: 30,),
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.indigoAccent,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextButton(
                    child: Text('Update Post', style: TextStyle(color: Colors.white, fontSize: 20),),
                    onPressed: _apiCreatePost,
                  ),
                ),
              ],
            ),
          ),

          isLoading ? Center(child: CircularProgressIndicator()) : SizedBox.shrink(),
        ],
      ),
    );
  }
}
