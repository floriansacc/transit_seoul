class GeneralDbDataModel {
  const GeneralDbDataModel({
    this.indexId = 0,
    required this.isLogin,
    this.userName,
    this.email,
    this.userId,
    this.picture,
  });

  final int indexId;
  final bool isLogin;
  final String? userName;
  final String? email;
  final String? userId;
  final String? picture;

  static GeneralDbDataModel fromJson(Map<String, dynamic> json) {
    return GeneralDbDataModel(
      indexId: json['indexId'] as int? ?? 0,
      isLogin: (json['isLogin'] as int?) == 1,
      userName: json['userName'] as String?,
      email: json['email'] as String?,
      userId: json['userId'] as String?,
      picture: json['picture'] as String?,
    );
  }

  GeneralDbDataModel copyWith({
    bool? isLogin,
    String? userName,
    String? email,
    String? userId,
    String? picture,
  }) {
    return GeneralDbDataModel(
      isLogin: isLogin ?? this.isLogin,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      userId: userId ?? this.userId,
      picture: picture ?? this.picture,
    );
  }

  Map<String, dynamic> toJsonSql() {
    return {
      'indexId': 0,
      'isLogin': isLogin == true ? 1 : 0,
      'userName': userName,
      'email': email,
      'userId': userId,
      'picture': picture,
    };
  }
}
