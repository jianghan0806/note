import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes1/ui/search.dart';
import 'package:notes1/ui/write.dart';
import 'package:notes1/ui/list.dart'; // Updated import
import 'package:notes1/ui/calendar.dart'; // Updated import
import 'package:notes1/ui/center.dart';
import 'package:notes1/utils/tost_utils.dart'; // Double check the location of this import
import '../entity/user.dart';
import '../utils/api_service.dart';

class HomePage extends StatefulWidget {
  final User user;
  final ApiService apiService;

  HomePage({required this.user, required this.apiService});

  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  var _pageController = PageController(initialPage: 0);
  int last = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Material(
        child: SafeArea(
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
              child: Offstage(
                offstage: _selectedIndex == 2,
                child: AppBar(
                  backgroundColor: Color.fromRGBO(244, 244, 244, 1),
                  title: Text('备忘录'),
                  primary: true,
                  automaticallyImplyLeading: false,
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.search),
                      tooltip: '搜索',
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return SearchPage(apiService: widget.apiService, user: widget.user);
                        }));
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      tooltip: '写日记',
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return WritePage(apiService: widget.apiService, user: widget.user, id: -1);
                        }));
                      },
                    ),
                  ],
                ),
              ),
            ),
            body: SafeArea(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onItemTapped,
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  ListPage(apiService: widget.apiService, userId: widget.user.id!, user: widget.user),
                  CalendarPage(apiService: widget.apiService, userId: widget.user.id!),
                  CenterPage(apiService: widget.apiService, user: widget.user),
                ],
              ),
            ),
            bottomNavigationBar: CupertinoTabBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  activeIcon: Icon(Icons.event_note, color: Colors.blue[300]),
                  icon: Icon(Icons.event_note),
                  label: '主页',
                ),
                BottomNavigationBarItem(
                  activeIcon: Icon(Icons.calendar_today, color: Colors.blue[300]),
                  icon: Icon(Icons.calendar_today),
                  label: '日历',
                ),
                BottomNavigationBarItem(
                  activeIcon: Icon(Icons.person, color: Colors.blue[300]),
                  icon: Icon(Icons.person),
                  label: '个人中心',
                ),
              ],
              currentIndex: _selectedIndex,
              onTap: setPageViewItemSelect,
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() {
    int now = DateTime.now().millisecondsSinceEpoch;
    if (now - last > 1000) {
      last = now;
      Toast.show("再按一次返回键退出");
      return Future.value(false); // Do not exit
    } else {
      return Future.value(true); // Exit
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
  }

  void setPageViewItemSelect(int indexSelect) {
    _pageController.animateToPage(
      indexSelect,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }
}
