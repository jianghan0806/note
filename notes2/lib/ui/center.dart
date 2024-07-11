// CenterPage 代码
import 'package:flutter/material.dart';
import '../entity/user.dart';
import '../utils/api_service.dart';  // 引入 ApiService
import 'edit.dart';
import 'about.dart';
import 'MyFavoritesPage.dart';
import 'settings_page.dart';  // 引入 SettingsPage
import 'feedback.dart';  // 引入 FeedbackPage

class CenterPage extends StatefulWidget {
  const CenterPage({
    Key? key,
    required this.apiService,
    required this.user,
  }) : super(key: key);

  final ApiService apiService;  // 使用 ApiService
  final User user;

  @override
  State<StatefulWidget> createState() {
    return CenterPageState();
  }
}

class CenterPageState extends State<CenterPage> with AutomaticKeepAliveClientMixin {
  late User currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(244, 244, 244, 1),
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 5,
              ),
              Container(
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                padding: EdgeInsets.all(3),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                  backgroundImage: AssetImage('assets/images/huang.svg'), // 修改此处
                  radius: 30.0,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    currentUser.username,
                    style: TextStyle(color: Colors.black, fontSize: 26),
                  ),
                  GestureDetector(
                    onTap: _editProfile,
                    child: Text(
                      "编辑资料",
                      style: TextStyle(color: Color.fromRGBO(162, 162, 162, 1), fontSize: 18),
                    ),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: Container(
              child: Column(
                children: <Widget>[
                  Flexible(
                    child: Row(
                      children: <Widget>[
                        _buildItem(0),
                        _buildItem(1),
                      ],
                    ),
                    flex: 1,
                  ),
                  Flexible(
                    child: Row(
                      children: <Widget>[
                        _buildItem(2),
                        _buildItem(3),
                      ],
                    ),
                    flex: 1,
                  ),
                  Flexible(
                    child: Row(
                      children: <Widget>[
                        _buildItem(4),
                        _buildItem(5),
                      ],
                    ),
                    flex: 1,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  void _editProfile() async {
    final updatedUser = await Navigator.push<User>(
      context,
      MaterialPageRoute(
        builder: (context) => EditUserInfoPage(
          user: currentUser,
          apiService: widget.apiService,  // 传递 ApiService 实例
        ),
      ),
    );
    if (updatedUser != null) {
      setState(() {
        currentUser = updatedUser;
      });
      await widget.apiService.updateUser(currentUser);  // 更新用户信息
    }
  }

  Widget _buildItem(int index) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
        child: GestureDetector(
          child: Card(
            child: Container(
              padding: EdgeInsets.all(26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _icons.elementAt(index),
                  Expanded(child: Text("")),
                  _title.elementAt(index),
                  _des.elementAt(index),
                ],
              ),
            ),
          ),
          onTap: () {
            _click(index);
          },
        ),
      ),
      flex: 1,
    );
  }

  void _click(int index) {
    switch (index) {
      case 0:
        _navigateToMyFavorites();
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return SettingsPage(
            fontSize: 16.0,  // 传递初始字体大小
            onFontSizeChanged: (double? newSize) {
              setState(() {
                // 处理字体大小的变化
              });
            },
          );
        }));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return FeedbackPage(
            apiService: widget.apiService,
            currentUserId: currentUser.id!,
          );
        }));
        break;
      case 4:
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return AboutPage();
        }));
        break;
    // Handle more clicks here
    }
  }

  void _navigateToMyFavorites() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return MyFavoritesPage(user: currentUser, apiService: widget.apiService);
    }));
  }

  List<Icon> _icons = [
    Icon(
      Icons.favorite,
      size: 38,
      color: Colors.yellow,
    ),
    Icon(
      Icons.lock,
      size: 38,
      color: Colors.blue,
    ),
    Icon(
      Icons.feedback,
      size: 38,
      color: Colors.blueAccent,
    ),
    Icon(
      Icons.share,
      size: 38,
      color: Colors.deepPurpleAccent,
    ),
    Icon(
      Icons.error_outline,
      size: 38,
      color: Colors.orange,
    ),
    Icon(
      Icons.settings,
      size: 38,
      color: Colors.red,
    ),
  ];

  List<Text> _title = [
    Text(
      "我的收藏",
      style: TextStyle(color: Colors.black, fontSize: 20),
    ),
    Text(
      "系统设置",
      style: TextStyle(color: Colors.black, fontSize: 20),
    ),
    Text(
      "吐槽反馈",
      style: TextStyle(color: Colors.black, fontSize: 20),
    ),
    Text(
      "分享",
      style: TextStyle(color: Colors.black, fontSize: 20),
    ),
    Text(
      "关于日记",
      style: TextStyle(color: Colors.black, fontSize: 20),
    ),
    Text(
      "系统设置",
      style: TextStyle(color: Colors.black, fontSize: 20),
    ),
  ];

  List<Text> _des = [
    Text(
      "收藏的重要日记",
      style: TextStyle(color: Color.fromRGBO(162, 162, 162, 1), fontSize: 16),
    ),
    Text(
      "设置系统参数",
      style: TextStyle(color: Color.fromRGBO(162, 162, 162, 1), fontSize: 16),
    ),
    Text(
      "留下真挚的建议",
      style: TextStyle(color: Color.fromRGBO(162, 162, 162, 1), fontSize: 16),
    ),
    Text(
      "分享应用给他人",
      style: TextStyle(color: Color.fromRGBO(162, 162, 162, 1), fontSize: 16),
    ),
    Text(
      "版本信息",
      style: TextStyle(color: Color.fromRGBO(162, 162, 162, 1), fontSize: 16),
    ),
    Text(
      "系统相关设置",
      style: TextStyle(color: Color.fromRGBO(162, 162, 162, 1), fontSize: 16),
    ),
  ];

  @override
  bool get wantKeepAlive => true;
}