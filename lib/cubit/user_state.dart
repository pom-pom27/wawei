part of 'user_cubit.dart';

@immutable
abstract class UserState {}

class UserInitial extends UserState {}

class UserLoaded extends UserState {
  final User user;

  UserLoaded({required this.user});
}

class UserFailure extends UserState {}
