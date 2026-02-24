class UserInfo {
  int _userId = 0;
  String _username = '';
  String _email = '';
  String _password = '';

  // Getters
  int get userId => _userId;
  String get username => _username;
  String get email => _email;
  String get password => _password;

  // Setters
  set userId(int value) => _userId = value;
  set username(String value) => _username = value;
  set email(String value) => _email = value;
  set password(String value) => _password = value;


// Constructor
  UserInfo({int userId = 0, String username = '', String email = '', String password = ''}) {
    _userId = userId;
    _username = username;
    _email = email;
    _password = password;
  }

  // Convert UserInfo to Map (for saving in SharedPreferences)
  Map<String, dynamic> toJson() {
    return {
      'userId': _userId,
      'username': _username,
      'email': _email,
      'password': _password,
    };
  }

  // Create UserInfo from Map (when reading from SharedPreferences)
  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      userId: json['userId'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
    );
  }
}