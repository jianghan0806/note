import 'package:flutter/material.dart';
import '../entity/user.dart';
import '../utils/api_service.dart'; // 引入 ApiService

class EditUserInfoPage extends StatefulWidget {
  final User user;
  final ApiService apiService; // 添加 ApiService

  EditUserInfoPage({required this.user, required this.apiService});

  @override
  _EditUserInfoPageState createState() => _EditUserInfoPageState();
}

class _EditUserInfoPageState extends State<EditUserInfoPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _sexController = TextEditingController();
  final TextEditingController _constellationController = TextEditingController();
  final TextEditingController _hobbyController = TextEditingController();
  final TextEditingController _mbtiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.user.username;
    _passwordController.text = widget.user.password;
    _sexController.text = widget.user.sex;
    _constellationController.text = widget.user.constellation;
    _hobbyController.text = widget.user.hobby;
    _mbtiController.text = widget.user.signature;
  }

  void _updateUser() async {
    User updatedUser = widget.user.copyWith(
      username: _usernameController.text,
      password: _passwordController.text,
      sex: _sexController.text,
      constellation: _constellationController.text,
      hobby: _hobbyController.text,
      signature: _mbtiController.text,
    );
    try {
      await widget.apiService.updateUser(updatedUser);
      Navigator.pop(context, updatedUser);
    } catch (e) {
      print('Failed to update user: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('更新用户信息失败')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('个人信息编辑'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/user_avatar.png'), // Add user avatar image here
              ),
              SizedBox(height: 20),
              Text(
                'Edit Your Profile',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: '用户名',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: '密码',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _sexController,
                decoration: InputDecoration(
                  labelText: '性别',
                  prefixIcon: Icon(Icons.wc),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _constellationController,
                decoration: InputDecoration(
                  labelText: '星座',
                  prefixIcon: Icon(Icons.star),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _hobbyController,
                decoration: InputDecoration(
                  labelText: '爱好',
                  prefixIcon: Icon(Icons.favorite),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _mbtiController,
                decoration: InputDecoration(
                  labelText: 'MBTI',
                  prefixIcon: Icon(Icons.emoji_people),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _updateUser,
                child: Text('确认', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
