import 'package:flutter/material.dart';
import 'package:notes1/entity/note.dart';
import 'package:notes1/entity/user.dart';
import 'package:notes1/utils/event_bus.dart';
import 'package:notes1/utils/api_service.dart';
import 'package:notes1/utils/tost_utils.dart';

class WritePage extends StatefulWidget {
  const WritePage({
    Key? key,
    required this.apiService,
    required this.id,
    required this.user,
  }) : super(key: key);

  final ApiService apiService;
  final int id;
  final User user;

  @override
  State<StatefulWidget> createState() {
    return WritePageState();
  }
}

class WritePageState extends State<WritePage> {
  String notes = "";
  int selectedMood = 0;
  int starStatus = 0; // Added to track star status
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    if (widget.id != -1) {
      widget.apiService.getNoteById(widget.id).then((note) {
        setState(() {
          notes = note?.content ?? "";
          selectedMood = note?.mood ?? 0;
          starStatus = note?.star ?? 0; // Initialize star status
          _controller.text = notes;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(244, 244, 244, 1),
        title: Text("书写日记"),
        actions: <Widget>[
          TextButton(
            child: Text(
              "保存",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            onPressed: () {
              save(context);
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                color: Colors.white,
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                  minWidth: MediaQuery.of(context).size.width,
                ),
                padding: EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 8.0,
                  bottom: 4.0,
                ),
                child: TextField(
                  controller: _controller,
                  onChanged: (text) {
                    setState(() {
                      notes = text;
                    });
                  },
                  maxLines: null,
                  style: TextStyle(),
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration.collapsed(
                    hintText: "点此输入你的内容",
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    starStatus == 1 ? Icons.star : Icons.star_border,
                    color: starStatus == 1 ? Colors.yellow : Colors.grey,
                  ),
                  onPressed: () {
                    toggleStar(); // Toggle star status
                  },
                ),
                PopupMenuButton<int>(
                  icon: Icon(Icons.mood, color: Colors.grey),
                  onSelected: (int value) {
                    setState(() {
                      selectedMood = value;
                    });
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                    PopupMenuItem<int>(
                      value: 0,
                      child: Text('开心'),
                    ),
                    PopupMenuItem<int>(
                      value: 1,
                      child: Text('悲伤'),
                    ),
                    PopupMenuItem<int>(
                      value: 2,
                      child: Text('生气'),
                    ),
                    PopupMenuItem<int>(
                      value: 3,
                      child: Text('平静'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void toggleStar() {
    setState(() {
      starStatus = 1 - starStatus; // Toggle between 0 and 1
    });
  }

  void save(BuildContext context) async {
    if (notes.trim().isEmpty) {
      Toast.show("内容不能为空");
      return;
    }
    Toast.show("已保存");
    Note note = Note(
      id: widget.id != -1 ? widget.id : null,
      userId: widget.user.id!,
      title: "日记",
      content: notes,
      time: DateTime.now().millisecondsSinceEpoch,
      star: starStatus, // Assign star status to note
      weather: 0,
      mood: selectedMood,
    );
    try {
      if (widget.id != -1) {
        await widget.apiService.updateNote(note);
      } else {
        await widget.apiService.insertNote(note);
        if (starStatus == 1) {
          eventBus.fire(NoteEvent(note.id ?? -1)); // Fire event if starred
        }
      }
      Navigator.pop(context);
    } catch (e) {
      Toast.show("保存失败: $e");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
