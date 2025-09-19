part of 'user_cubit.dart';

enum UserStatus { initial, loading, done, loggedIn, fail }

extension UserStatusX on UserStatus {
  bool get isInitial => this == UserStatus.initial;
  bool get isLoading => this == UserStatus.loading;
  bool get isDone => this == UserStatus.done;
  bool get isLoggedIn => this == UserStatus.loggedIn;
  bool get isFailed => this == UserStatus.fail;
}

class UserState extends Equatable {
  const UserState({
    this.status = UserStatus.initial,
    this.userData,
  });

  final UserStatus status;
  final GeneralDbDataModel? userData;

  UserState copyWith({
    UserStatus? status,
    GeneralDbDataModel? userData,
  }) {
    return UserState(
      status: status ?? this.status,
      userData: userData ?? this.userData,
    );
  }

  @override
  List<Object?> get props => [status, userData];
}
