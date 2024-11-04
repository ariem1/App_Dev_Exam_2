class User{
  final int id;
  final String password;

  User({required this.id, required this.password});

  Map<String, Object> toMap(){
    return {
      'userId': id,
      'password': password
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['userId'],
      password: map['password'],
    );
  }

  @override
  String toString() {
    return 'User{ id: $id, password: $password}';
  }
}