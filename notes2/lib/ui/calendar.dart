import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../entity/note.dart';
import '../utils/api_service.dart';  // 确保导入路径正确

class CalendarPage extends StatefulWidget {
  final ApiService apiService;
  final int userId;

  const CalendarPage({Key? key, required this.apiService, required this.userId}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime? _selectedDay;
  late List<Note> _notesForSelectedDay;
  late String _moodSummary;

  final Map<int, String> _moodDescriptions = {
    0: '开心',
    1: '悲伤',
    2: '生气',
    3: '平静',
  };

  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
    _notesForSelectedDay = [];
    _moodSummary = '';
    _fetchNotesForSelectedDay(_selectedDay!);
  }

  Future<void> _fetchNotesForSelectedDay(DateTime date) async {
    try {
      final notes = await widget.apiService.getNotesByUserId(widget.userId);
      setState(() {
        _notesForSelectedDay = notes.where((note) {
          final noteDate = DateTime.fromMillisecondsSinceEpoch(note.time!);
          return noteDate.year == date.year && noteDate.month == date.month && noteDate.day == date.day;
        }).toList();
        _moodSummary = _generateMoodSummary(_notesForSelectedDay);
      });
    } catch (e) {
      print('Failed to fetch notes: $e');
    }
  }

  String _generateMoodSummary(List<Note> notes) {
    Map<int, int> moodCount = {};
    for (var note in notes) {
      moodCount[note.mood!] = (moodCount[note.mood!] ?? 0) + 1;
    }
    if (moodCount.isEmpty) {
      return 'No moods recorded for today';
    }
    var sortedMoods = moodCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    var topMood = sortedMoods.first;
    return '还是蛮${_moodDescriptions[topMood.key]}的';
  }

  void _addOrEditNoteDialog({Note? note}) {
    final _formKey = GlobalKey<FormState>();
    final _titleController = TextEditingController(text: note?.title ?? '');
    final _contentController = TextEditingController(text: note?.content ?? '');
    int? _selectedMood = note?.mood;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(note == null ? '添加事件' : '编辑事件'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: '标题'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入标题';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _contentController,
                  decoration: InputDecoration(labelText: '内容'),
                ),
                DropdownButtonFormField<int>(
                  value: _selectedMood,
                  decoration: InputDecoration(labelText: '心情'),
                  items: _moodDescriptions.entries
                      .map((entry) => DropdownMenuItem<int>(
                    value: entry.key,
                    child: Text(entry.value),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedMood = value;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('取消'),
            ),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final newNote = Note(
                    id: note?.id,
                    userId: widget.userId,
                    title: _titleController.text,
                    content: _contentController.text,
                    time: note?.time ?? DateTime.now().millisecondsSinceEpoch,
                    mood: _selectedMood,
                  );
                  if (note == null) {
                    await widget.apiService.insertNote(newNote);
                  } else {
                    await widget.apiService.updateNote(newNote);
                  }
                  _fetchNotesForSelectedDay(_selectedDay!);
                  Navigator.of(context).pop();
                }
              },
              child: Text(note == null ? '添加' : '保存'),
            ),
          ],
        );
      },
    );
  }

  void _deleteNoteDialog(Note note) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('删除事件'),
          content: Text('确定要删除这个事件吗？'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('取消'),
            ),
            TextButton(
              onPressed: () async {
                await widget.apiService.deleteNote(note.id!);
                _fetchNotesForSelectedDay(_selectedDay!);
                Navigator.of(context).pop();
              },
              child: Text('删除'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _addOrEditNoteDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2000, 1, 1),
            lastDay: DateTime.utc(2100, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay; // update _focusedDay here as well
              });
              _fetchNotesForSelectedDay(selectedDay);
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(_moodSummary, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: _notesForSelectedDay.isEmpty
                ? Center(child: Text('No notes for selected day'))
                : ListView.builder(
              itemCount: _notesForSelectedDay.length,
              itemBuilder: (context, index) {
                final note = _notesForSelectedDay[index];
                final moodDescription = _moodDescriptions[note.mood] ?? 'N/A';
                return ListTile(
                  leading: IconButton(
                    icon: Icon(
                      note.star == 1 ? Icons.star : Icons.star_border,
                      color: note.star == 1 ? Colors.yellow : null,
                    ),
                    onPressed: () async {
                      await widget.apiService.updateNoteStarById(note.id!, note.star == 1 ? 0 : 1);
                      _fetchNotesForSelectedDay(_selectedDay!);
                    },
                  ),
                  title: Text(note.title ?? 'No Title'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Mood: $moodDescription'),
                      Text('Content: ${note.content ?? ''}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _addOrEditNoteDialog(note: note),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteNoteDialog(note),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
