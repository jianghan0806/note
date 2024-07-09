import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes1/entity/note.dart';
import 'package:notes1/ui/read.dart';
import 'package:notes1/utils/event_bus.dart';
import 'package:notes1/utils/time_utils.dart';
import '../entity/user.dart';
import '../utils/api_service.dart'; // Import ApiService

class ListPage extends StatefulWidget {
  const ListPage({
    Key? key,
    required this.apiService,
    required this.userId,
    required this.user,
  }) : super(key: key);

  final ApiService apiService; // Use ApiService
  final int userId;
  final User user;

  @override
  State<StatefulWidget> createState() {
    return ListPageState();
  }
}

class ListPageState extends State<ListPage> with AutomaticKeepAliveClientMixin {
  ScrollController _scrollController =
  ScrollController(initialScrollOffset: 5, keepScrollOffset: true);
  int _size = 0;
  List<Note> _noteList = [];
  late StreamSubscription subscription;

  @override
  void initState() {
    super.initState();
    subscription = eventBus.on<NoteEvent>().listen((NoteEvent event) {
      _onRefresh();
    });
    _scrollController.addListener(() {});
    _onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: RefreshIndicator(
        child: CustomScrollView(
          shrinkWrap: false,
          primary: false,
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          controller: _scrollController,
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
                    child: getItem(index),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return ReadPage(
                          id: _noteList.elementAt(index).id!,
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
        onRefresh: _onRefresh,
      ),
    );
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
                Clipboard.setData(ClipboardData(
                    text: _noteList.elementAt(index).content!));
                ScaffoldMessenger.of(c).showSnackBar(SnackBar(
                  content: Text("已经复制到剪贴板"),
                  backgroundColor: Colors.black87,
                  duration: Duration(
                    seconds: 2,
                  ),
                ));
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete_sweep),
              title: Text("删除"),
              onTap: () async {
                await widget.apiService.deleteNote(_noteList.elementAt(index).id!);
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
                        '${DateTime.fromMillisecondsSinceEpoch(_noteList[index].time!).day}',
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
                            '星期${TimeUtils.getWeekday(DateTime.fromMillisecondsSinceEpoch(_noteList[index].time!).weekday)}',
                            style: TextStyle(
                              color: Color.fromRGBO(149, 149, 148, 1),
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            TimeUtils.getDate(
                              DateTime.fromMillisecondsSinceEpoch(
                                  _noteList[index].time!),
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
                      getMoodIcon(_noteList[index].mood),
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

  @override
  bool get wantKeepAlive => true;

  Future<void> _onRefresh() async {
    List<Note> notes = await widget.apiService.getNotesByUserId(widget.userId);
    setState(() {
      _noteList = notes;
      _size = _noteList.length;
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }
}
