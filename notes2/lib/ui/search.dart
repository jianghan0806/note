import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes1/entity/note.dart';
import 'package:notes1/entity/user.dart';
import 'package:notes1/utils/api_service.dart';
import 'package:notes1/utils/time_utils.dart';
import 'package:notes1/utils/tost_utils.dart';
import 'read.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({
    Key? key,
    required this.apiService,
    required this.user,
  }) : super(key: key);

  final ApiService apiService;
  final User user;

  @override
  State<StatefulWidget> createState() {
    return SearchPageState();
  }
}

class SearchPageState extends State<SearchPage> {
  int _size = 0;
  List<Note> _noteList = [];
  String keyString = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        primary: true,
        backgroundColor: Color.fromRGBO(244, 244, 244, 1),
        elevation: 1,
        automaticallyImplyLeading: true,
        title: Container(
          padding: EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 10),
          child: TextField(
            maxLines: 1,
            autofocus: false,
            onChanged: (text) {
              setState(() {
                keyString = text;
              });
            },
            decoration: InputDecoration(
              filled: true,
              contentPadding: EdgeInsets.all(10),
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                gapPadding: 0,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              hintText: '请输入搜索关键字...',
              suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  setState(() {
                    keyString = "";
                  });
                },
              ),
            ),
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.only(left: 0.0, right: 10.0),
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            width: 100,
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
              ),
              onPressed: () {
                _search();
              },
              child: Text("搜索"),
            ),
          )
        ],
      ),
      body: Container(
        child: CustomScrollView(
          shrinkWrap: false,
          primary: false,
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: SizedBox(
                height: 10,
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return InkWell(
                    child: index % 2 == 0 ? getItem(index) : getImageItem(index),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return ReadPage(
                          id: _noteList[index].id!,
                          apiService: widget.apiService,
                          user: widget.user,
                        );
                      }));
                    },
                    onLongPress: () {
                      _showBottomSheet(index, context);
                    },
                  );
                },
                childCount: _size,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _search() async {
    await Future.delayed(Duration(seconds: 0), () {
      widget.apiService.getNotesByKeywordAndUserId(keyString, widget.user.id!).then((List<Note> notes) {
        setState(() {
          _size = notes.length;
          _noteList = notes;
        });
      });
    });
  }

  _showBottomSheet(int index, BuildContext c) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.content_copy),
              title: Text("复制"),
              onTap: () async {
                Clipboard.setData(ClipboardData(text: _noteList[index].content!));
                ScaffoldMessenger.of(c).showSnackBar(SnackBar(
                  content: Text("已经复制到剪贴板"),
                  backgroundColor: Colors.black87,
                  duration: Duration(seconds: 2),
                ));
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete_sweep),
              title: Text("删除"),
              onTap: () async {
                await widget.apiService.deleteNote(_noteList[index].id!);
                setState(() {
                  _noteList.removeAt(index);
                  _size = _noteList.length;
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Widget getItem(int index) {
    if (_noteList.isEmpty) {
      return Container(); // Placeholder for empty state
    }

    return Container(
      child: Card(
        margin: EdgeInsets.fromLTRB(10, 8, 10, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '${DateTime.fromMillisecondsSinceEpoch(_noteList[index].time ?? 0).day}',
                        style: TextStyle(
                          color: Color.fromRGBO(52, 52, 54, 1),
                          fontSize: 50,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '星期${TimeUtils.getWeekday(DateTime.fromMillisecondsSinceEpoch(_noteList[index].time ?? 0).weekday)}',
                            style: TextStyle(
                              color: Color.fromRGBO(149, 149, 148, 1),
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            TimeUtils.getDate(
                              DateTime.fromMillisecondsSinceEpoch(_noteList[index].time ?? 0),
                            ),
                            style: TextStyle(
                              color: Color.fromRGBO(149, 149, 148, 1),
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.fromLTRB(0, 5, 20, 5),
                    child: Icon(
                      getMoodIcon(_noteList[index].mood ?? 0),
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: Text(
                _noteList[index].content!,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Color.fromRGBO(103, 103, 103, 1),
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData getMoodIcon(int? mood) {
    switch (mood) {
      case 0:
        return Icons.sentiment_satisfied;
      case 1:
        return Icons.sentiment_dissatisfied;
      case 2:
        return Icons.sentiment_very_dissatisfied;
      case 3:
        return Icons.sentiment_neutral;
      default:
        return Icons.sentiment_satisfied;
    }
  }

  Widget getImageItem(int index) {
    return Container(
      child: Card(
        margin: EdgeInsets.fromLTRB(10, 8, 10, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '${DateTime.fromMillisecondsSinceEpoch(_noteList.elementAt(index).time ?? 0).day}',
                        style: TextStyle(
                          color: Color.fromRGBO(52, 52, 54, 1),
                          fontSize: 50,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(width: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '星期${TimeUtils.getWeekday(DateTime.fromMillisecondsSinceEpoch(_noteList.elementAt(index).time ?? 0).weekday)}',
                            style: TextStyle(
                              color: Color.fromRGBO(149, 149, 148, 1),
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            TimeUtils.getDate(
                              DateTime.fromMillisecondsSinceEpoch(_noteList.elementAt(index).time ?? 0),
                            ),
                            style: TextStyle(
                              color: Color.fromRGBO(149, 149, 148, 1),
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.fromLTRB(0, 5, 20, 5),
                    child: Icon(
                      getMoodIcon(_noteList.elementAt(index).mood ?? 0),
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: Image.network(
                _noteList.elementAt(index).content!,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
