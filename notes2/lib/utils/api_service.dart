import 'package:dio/dio.dart';
import '../entity/note.dart';
import '../entity/user.dart';
import '../entity/user_feedback.dart';

class ApiService {
  final Dio _dio = Dio();
  final String notesUrl = 'http://localhost:8086/notes';
  final String usersUrl = 'http://localhost:8086/users';
  final String feedbacksUrl = 'http://localhost:8086/feedbacks';

  // Note相关操作
  // 获取所有Note
  Future<List<Note>> getAllNotes() async {
    try {
      final response = await _dio.get(notesUrl);
      return (response.data as List).map((item) => Note.fromMap(item)).toList();
    } catch (e) {
      throw Exception('Failed to load notes: $e');
    }
  }

  // 通过ID获取Note
  Future<Note?> getNoteById(int id) async {
    try {
      final response = await _dio.get('$notesUrl/$id');
      return Note.fromMap(response.data);
    } catch (e) {
      throw Exception('Failed to get note by id: $e');
    }
  }

  // 插入新的Note
  Future<void> insertNote(Note note) async {
    try {
      await _dio.post(notesUrl, data: note.toMap());
    } catch (e) {
      throw Exception('Failed to insert note: $e');
    }
  }

  // 更新现有的Note
  Future<void> updateNote(Note note) async {
    try {
      await _dio.put('$notesUrl/${note.id}', data: note.toMap());
    } catch (e) {
      throw Exception('Failed to update note: $e');
    }
  }

  // 删除Note
  Future<void> deleteNote(int id) async {
    try {
      await _dio.delete('$notesUrl/$id');
    } catch (e) {
      throw Exception('Failed to delete note: $e');
    }
  }

  // 根据userId获取Notes
  Future<List<Note>> getNotesByUserId(int userId) async {
    try {
      final response = await _dio.get('$notesUrl/user/$userId');
      return (response.data as List).map((item) => Note.fromMap(item)).toList();
    } catch (e) {
      throw Exception('Failed to load notes by userId: $e');
    }
  }

  // 根据关键词和userId获取Notes
  Future<List<Note>> getNotesByKeywordAndUserId(String keyword, int userId) async {
    try {
      final response = await _dio.get('$notesUrl/search', queryParameters: {
        'keyword': keyword,
        'userId': userId,
      });
      return (response.data as List).map((item) => Note.fromMap(item)).toList();
    } catch (e) {
      throw Exception('Failed to load notes by keyword and userId: $e');
    }
  }

  // 根据userId和star状态获取Notes
  Future<List<Note>> getNotesByUserIdAndStar(int userId, int starStatus) async {
    try {
      final response = await _dio.get('$notesUrl/star', queryParameters: {
        'userId': userId,
        'star': starStatus,
      });
      return (response.data as List).map((item) => Note.fromMap(item)).toList();
    } catch (e) {
      throw Exception('Failed to load notes by userId and star: $e');
    }
  }

  // 更新Note的star状态
  Future<void> updateNoteStarById(int id, int starStatus) async {
    try {
      await _dio.patch('$notesUrl/$id/star', data: {'star': starStatus});
    } catch (e) {
      throw Exception('Failed to update note star: $e');
    }
  }

  // User相关操作
  // 获取所有User
  Future<List<User>> getAllUsers() async {
    try {
      final response = await _dio.get(usersUrl);
      return (response.data as List).map((item) => User.fromMap(item)).toList();
    } catch (e) {
      throw Exception('Failed to load users: $e');
    }
  }

  // 通过ID获取User
  Future<User?> getUserById(int id) async {
    try {
      final response = await _dio.get('$usersUrl/$id');
      return User.fromMap(response.data);
    } catch (e) {
      throw Exception('Failed to get user by id: $e');
    }
  }

  // 插入新的User
  Future<void> insertUser(User user) async {
    try {
      await _dio.post(usersUrl, data: user.toMap());
    } catch (e) {
      throw Exception('Failed to insert user: $e');
    }
  }

  // 更新现有的User
  Future<void> updateUser(User user) async {
    try {
      await _dio.put('$usersUrl/${user.id}', data: user.toMap());
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  // 删除User
  Future<void> deleteUser(int id) async {
    try {
      await _dio.delete('$usersUrl/$id');
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  // 根据用户名和密码查找User
  Future<User?> getUserByUsernameAndPassword(String username, String password) async {
    try {
      final response = await _dio.get('$usersUrl/search', queryParameters: {
        'username': username,
        'password': password,
      });
      return User.fromMap(response.data);
    } catch (e) {
      throw Exception('Failed to load user by username and password: $e');
    }
  }

  // 根据用户名查找User
  Future<List<User>> getUserByUsername(String username) async {
    try {
      final response = await _dio.get('$usersUrl/search/username', queryParameters: {
        'username': username,
      });
      return (response.data as List).map((item) => User.fromMap(item)).toList();
    } catch (e) {
      throw Exception('Failed to load user by username: $e');
    }
  }
  // UserFeedback相关操作
  Future<void> saveFeedback(UserFeedback feedback) async {
    try {
      await _dio.post(feedbacksUrl, data: feedback.toMap());
    } catch (e) {
      throw Exception('Failed to save feedback: $e');
    }
  }

  Future<List<UserFeedback>> getAllFeedbacks() async {
    try {
      final response = await _dio.get(feedbacksUrl);
      return (response.data as List).map((item) => UserFeedback.fromMap(item)).toList();
    } catch (e) {
      throw Exception('Failed to load feedbacks: $e');
    }
  }
}
