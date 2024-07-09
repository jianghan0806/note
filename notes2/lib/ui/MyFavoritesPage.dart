import 'package:flutter/material.dart';
import '../entity/note.dart';
import '../entity/user.dart';
import '../utils/api_service.dart'; // 引入 ApiService

class MyFavoritesPage extends StatefulWidget {
  final ApiService apiService; // 使用 ApiService
  final User user;

  const MyFavoritesPage({Key? key, required this.apiService, required this.user}) : super(key: key);

  @override
  _MyFavoritesPageState createState() => _MyFavoritesPageState();
}

class _MyFavoritesPageState extends State<MyFavoritesPage> {
  late List<Note> _favoriteNotes = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteNotes();
  }

  void _loadFavoriteNotes() async {
    try {
      List<Note> favoriteNotes = await widget.apiService.getNotesByUserIdAndStar(widget.user.id!, 1);
      setState(() {
        _favoriteNotes = favoriteNotes;
      });
    } catch (e) {
      print('Failed to load favorite notes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('我的收藏'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_favoriteNotes.isEmpty) {
      return Center(
        child: Text('暂无收藏的日记'),
      );
    } else {
      return ListView.builder(
        itemCount: _favoriteNotes.length,
        itemBuilder: (context, index) {
          final note = _favoriteNotes[index];
          return ListTile(
            title: Text(note.title ?? ''), // Handle nullable title
            subtitle: Text(note.content ?? ''), // Handle nullable content
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _unfavoriteNoteAtIndex(index);
              },
            ),
          );
        },
      );
    }
  }

  void _unfavoriteNoteAtIndex(int index) async {
    try {
      await widget.apiService.updateNoteStarById(_favoriteNotes[index].id!, 0);
      setState(() {
        _favoriteNotes.removeAt(index);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('已取消收藏')),
      );
    } catch (e) {
      print('Failed to unfavorite note: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('取消收藏失败')),
      );
    }
  }
}
