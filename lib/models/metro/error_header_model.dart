class ErrorHeaderModel {
  const ErrorHeaderModel({
    this.status,
    this.code,
    this.message,
    this.link,
    this.developerMessage,
    this.total,
  });

  final int? status;
  final String? code;
  final String? message;
  final String? link;
  final String? developerMessage;
  final int? total;

  static ErrorHeaderModel fromJson(Map<String, dynamic> json) {
    return ErrorHeaderModel(
      status: json['status'],
      code: json['code'],
      message: json['message'],
      link: json['link'],
      developerMessage: json['developerMessage'],
      total: json['total'],
    );
  }
}
