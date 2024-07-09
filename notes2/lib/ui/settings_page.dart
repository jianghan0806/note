import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  final double fontSize;
  final ValueChanged<double?> onFontSizeChanged; // 修改为 double?

  const SettingsPage({
    Key? key,
    required this.fontSize,
    required this.onFontSizeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('系统设置'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 20),
          ListTile(
            title: Text('退出登录'),
            onTap: () {
              _logout(context); // 调用退出登录方法
            },
          ),
          Divider(),
          ListTile(
            title: Text(''),
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context) {
    // 实现退出登录功能
    Navigator.pushReplacementNamed(context, '/login'); // 跳转到登录页面
  }
}
