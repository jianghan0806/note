class User {
  final int? id;
  final String username;
  final String password;
  final String sex;
  final String constellation;
  final String hobby;
  final String signature;

  const User({
    this.id,
    required this.username,
    required this.password,
    required this.sex,
    required this.constellation,
    required this.hobby,
    required this.signature,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'sex': sex,
      'constellation': constellation,
      'hobby': hobby,
      'signature': signature,
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      password: map['password'],
      sex: map['sex'],
      constellation: map['constellation'],
      hobby: map['hobby'],
      signature: map['signature'],
    );
  }

  User copyWith({
    int? id,
    String? username,
    String? password,
    String? sex,
    String? constellation,
    String? hobby,
    String? signature,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
      sex: sex ?? this.sex,
      constellation: constellation ?? this.constellation,
      hobby: hobby ?? this.hobby,
      signature: signature ?? this.signature,
    );
  }
}
