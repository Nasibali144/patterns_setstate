import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:patterns_setstate/models/post_model.dart';
import 'package:patterns_setstate/pages/create_page.dart';
import 'package:patterns_setstate/pages/update_page.dart';
import 'package:patterns_setstate/services/http_service.dart';

class HomePage extends StatefulWidget {

  static final String id = "home_page";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  List<Post> items = new List();

  void _apiPostList() async {
    setState(() {
      isLoading = true;
    });
    var response = await Network.GET(Network.API_LIST, Network.paramsEmpty());
    setState(() {
      if(response != null) {
        items = Network.parsePostList(response);
      } else {
        items = [];
      }
      isLoading = false;
    });
  }

  void _apiPostDelete(Post post) async {
    setState(() {
      isLoading = true;
    });
    var response = await Network.DEL(Network.API_DELETE + post.id.toString(), Network.paramsEmpty());
    print(response);
    setState(() {
      if(response != null) {
        //_apiPostList();
        items.remove(post);
      }
      isLoading = false;
    });
  }

  void _apiUpdatePost(Post post) async{
    String result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => UpdatePage(post: post,)));
    setState(() {
      Post newPost = Network.parsePost(result);
      items[items.indexWhere((element) => element.id == newPost.id)] = newPost;
    });
  }

  void _apiCreatePost() async{
    String result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreatePage()));
    setState(() {
      items.add(Network.parsePost(result));
    });
  }

  @override
  void initState() {
    super.initState();
    _apiPostList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Set State"),
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return itemOfPost(items[index]);
            },
          ),

          isLoading ? Center(
            child: CircularProgressIndicator(),
          ) : SizedBox.shrink(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        onPressed: _apiCreatePost,
      ),
    );
  }

  Widget itemOfPost(Post post) {
    return Slidable(
      child: Container(
        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post.title.toUpperCase(), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
            SizedBox(height: 5,),
            Text(post.body),
          ],
        ),
      ),
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      actions: [
        IconSlideAction(
          caption: 'Update',
          color: Colors.indigo,
          icon: Icons.edit,
          onTap: () {
            _apiUpdatePost(post);
          },
        ),
      ],
      secondaryActions: [
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            _apiPostDelete(post);
          },
        ),
      ],
    );
  }
}
