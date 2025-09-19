class UserLoginModel {
  const UserLoginModel({
    this.token,
    this.user,
  });

  final String? token;
  final UserModel? user;

  static UserLoginModel fromJson(Map<String, dynamic> json) {
    return UserLoginModel(
      token: json['token'],
      user: UserModel.fromJson(json['user']),
    );
  }
}

class UserModel {
  const UserModel({
    this.userId,
    this.email,
    this.name,
    this.picture,
  });
  final String? userId;
  final String? email;
  final String? name;
  final String? picture;

  static UserModel fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'],
      email: json['email'],
      name: json['name'],
      picture: json['picture'],
    );
  }
}
