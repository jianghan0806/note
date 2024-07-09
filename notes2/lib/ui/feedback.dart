import 'package:flutter/material.dart';
import 'package:notes1/utils/api_service.dart';  // 修改这个导入
import 'package:notes1/entity/user_feedback.dart';
import 'package:notes1/entity/user.dart';

class FeedbackPage extends StatefulWidget {
  final ApiService apiService;
  final int currentUserId;

  const FeedbackPage({
    Key? key,
    required this.apiService,
    required this.currentUserId,
  }) : super(key: key);

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  TextEditingController _feedbackController = TextEditingController();
  List<UserFeedback> _feedbackList = [];

  @override
  void initState() {
    super.initState();
    _loadFeedbacks();
  }

  void _loadFeedbacks() async {
    List<UserFeedback> feedbacks = await widget.apiService.getAllFeedbacks();
    setState(() {
      _feedbackList = feedbacks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('吐槽反馈'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _feedbackController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: '请输入你的吐槽...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _saveFeedback();
              },
              child: Text('提交'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: _buildFeedbackList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackList() {
    return ListView.builder(
      itemCount: _feedbackList.length,
      itemBuilder: (context, index) {
        UserFeedback feedback = _feedbackList[index];
        return ListTile(
          title: Text(feedback.feedback),
          subtitle: FutureBuilder<User?>(
            future: widget.apiService.getUserById(feedback.userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text('Loading...');
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                String username = snapshot.data?.username ?? 'Unknown';
                return Text('用户: $username, 时间: ${DateTime.fromMillisecondsSinceEpoch(feedback.timestamp)}');
              }
            },
          ),
        );
      },
    );
  }

  Future<void> _saveFeedback() async {
    String feedbackText = _feedbackController.text.trim();
    if (feedbackText.isNotEmpty) {
      UserFeedback userFeedback = UserFeedback(
        userId: widget.currentUserId,
        feedback: feedbackText,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      );

      await widget.apiService.saveFeedback(userFeedback);

      _feedbackController.clear();

      // Immediately update feedback list after saving
      _loadFeedbacks();
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('提示'),
          content: Text('请输入吐槽内容！'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('确认'),
            ),
          ],
        ),
      );
    }
  }
}
