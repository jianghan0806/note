import 'package:flutter/material.dart';
import '../entity/note.dart';
import '../entity/user.dart';
import '../utils/api_service.dart'; // Import ApiService
import 'write.dart';

class ReadPage extends StatefulWidget {
  final int id;
  final ApiService apiService;
  final User user;

  ReadPage({required this.id, required this.apiService, required this.user});

  @override
  _ReadPageState createState() => _ReadPageState();
}

class _ReadPageState extends State<ReadPage> {
  Note? note;

  @override
  void initState() {
    super.initState();
    _loadNote();
  }

  Future<void> _loadNote() async {
    note = await widget.apiService.getNoteById(widget.id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('阅读'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WritePage(
                    apiService: widget.apiService,
                    id: widget.id,
                    user: widget.user,
                  ),
                ),
              ).then((_) => _loadNote()); // Reload note after edit
            },
          ),
        ],
      ),
      body: note == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(note!.title ?? 'No Title', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(note!.content ?? 'No Content', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
