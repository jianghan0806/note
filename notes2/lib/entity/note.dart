class Note {
  final int? id;
  final int userId; // 新增字段，关联用户ID
  final String? title;
  final String? content;
  final int? time;
  final int? star;
  final int? weather;
  final int? mood;

  const Note({
    this.id,
    required this.userId, // 新增字段，关联用户ID
    this.title,
    this.content,
    this.time,
    this.star,
    this.weather,
    this.mood,
  });
  Map<String, dynamic> toMapForDB() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'content': content,
      'time': time,
      'star': star, // Ensure 'star' is saved correctly
      'weather': weather,
      'mood': mood,
    };
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId, // 新增字段，关联用户ID
      'title': title,
      'content': content,
      'time': time,
      'star': star,
      'weather': weather,
      'mood': mood,
    };
  }

  static Note fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      userId: map['userId'],
      title: map['title'],
      content: map['content'],
      time: map['time'],
      star: map['star'],
      weather: map['weather'],
      mood: map['mood'],
    );
  }

  Note copyWith({
    int? id,
    int? userId,
    String? title,
    String? content,
    int? time,
    int? star,
    int? weather,
    int? mood,
  }) {
    return Note(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      content: content ?? this.content,
      time: time ?? this.time,
      star: star ?? this.star,
      weather: weather ?? this.weather,
      mood: mood ?? this.mood,
    );
  }
}
