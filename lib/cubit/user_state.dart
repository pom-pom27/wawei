part of 'user_cubit.dart';

enum UserStatus { initial, loading, success, failure }

extension UserStatusX on UserStatus {
  bool get isInitial => this == UserStatus.initial;
  bool get isLoading => this == UserStatus.loading;
  bool get isSuccess => this == UserStatus.success;
  bool get isFailure => this == UserStatus.failure;
}

class UserState extends Equatable {
  final UserStatus status;
  final List<User> users;

  UserState({this.status = UserStatus.initial, List<User>? users})
      : users = users ?? List.empty();

  UserState copyWith({
    UserStatus? status,
    List<User>? users,
  }) {
    return UserState(
      status: status ?? this.status,
      users: users ?? this.users,
    );
  }

  @override
  List<Object?> get props => [status, users];
}
