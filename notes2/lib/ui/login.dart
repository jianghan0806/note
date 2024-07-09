import 'package:flutter/material.dart';
import 'home.dart';
import 'register.dart';
import 'package:notes1/utils/api_service.dart';
import 'package:notes1/entity/user.dart';

class LoginPage extends StatefulWidget {
  final ApiService apiService;

  LoginPage({required this.apiService});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    try {
      User? user = await widget.apiService.getUserByUsernameAndPassword(
        _usernameController.text,
        _passwordController.text,
      );
      if (user != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(apiService: widget.apiService, user: user)),
              (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('用户名或密码错误')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('登录失败: $e')),
      );
    }
  }

  void _navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RegisterPage(apiService: widget.apiService)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('闪亮日记本'),
    ),
    body: SingleChildScrollView(
    child: Padding(
    padding: EdgeInsets.all(16.0),
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    SizedBox(height: 60),
    CircleAvatar(
    radius: 50,
    backgroundImage: AssetImage('assets/images/huang.svg'), // Add your logo here
    ),
    SizedBox(height: 20),
    Text(
    'Nice to meet you here',
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
      SizedBox(height: 30),
      ElevatedButton(
        onPressed: _login,
        child: Text('登录', style: TextStyle(fontSize: 18)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        ),
      ),
      SizedBox(height: 20),
      TextButton(
        onPressed: _navigateToRegister,
        child: Text('没有账号？点击注册即可成为新用户'),
        style: TextButton.styleFrom(
          foregroundColor: Colors.brown,
          textStyle: TextStyle(decoration: TextDecoration.underline),
        ),
      ),
      SizedBox(height: 10),
      ElevatedButton(
        onPressed: _navigateToRegister,
        child: Text('注册', style: TextStyle(fontSize: 18)),
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

