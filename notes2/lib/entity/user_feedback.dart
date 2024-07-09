class UserFeedback {
  final int userId;
  final String feedback;
  final int timestamp;

  UserFeedback({
    required this.userId,
    required this.feedback,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'feedback': feedback,
      'timestamp': timestamp,
    };
  }

  factory UserFeedback.fromMap(Map<String, dynamic> map) {
    return UserFeedback(
      userId: map['userId'],
      feedback: map['feedback'],
      timestamp: map['timestamp'],
    );
  }
}
