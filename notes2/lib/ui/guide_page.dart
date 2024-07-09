import 'package:flutter/material.dart';
import 'package:notes1/ui/login.dart';
import 'package:notes1/utils/api_service.dart';

class GuidePage extends StatefulWidget {
  final ApiService apiService;

  GuidePage({required this.apiService});

  @override
  _GuidePageState createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            PageView(
              controller: _pageController,
              onPageChanged: _onSelectChanged,
              children: <Widget>[
                _buildPage(
                  'Shiny diary or memo',
                  '记录生活的点点滴滴\n\t\t\t\t\t\t重要事项提醒',
                  Color.fromRGBO(132, 112, 101, 1),
                  Color.fromRGBO(66, 84, 94, 1),
                ),
                _buildPage(
                  '功能丰富',
                  '超多功能等你解锁',
                  Color.fromRGBO(72, 186, 249, 1),
                  Color.fromRGBO(66, 84, 94, 1),
                ),
                _buildPage(
                  '或许，是专属于你的，闪亮日记本',
                  '立即体验>>',
                  Color.fromRGBO(98, 95, 78, 1),
                  Color.fromRGBO(66, 84, 94, 1),
                  isLastPage: true,
                ),
              ],
            ),
            _buildIndicators(),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(String title, String subtitle, Color titleColor, Color subtitleColor, {bool isLastPage = false}) {
    return Container(
      color: Color.fromRGBO(232, 229, 222, 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(color: titleColor, fontSize: 22),
          ),
          SizedBox(height: 10),
          isLastPage
              ? InkWell(
            onTap: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: Text(
              subtitle,
              style: TextStyle(color: subtitleColor, fontSize: 20),
            ),
          )
              : Text(
            subtitle,
            style: TextStyle(color: subtitleColor, fontSize: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicators() {
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildIndicator(0),
          _buildIndicator(1),
          _buildIndicator(2),
        ],
      ),
    );
  }

  Widget _buildIndicator(int index) {
    return Container(
      width: 10,
      height: 10,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: (_selectedIndex == index) ? Colors.white70 : Colors.black12,
      ),
    );
  }

  void _onSelectChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
