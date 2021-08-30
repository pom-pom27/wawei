import 'package:bloc/bloc.dart';
import 'package:jsonica/models/models.dart';
import 'package:jsonica/repositories/repositories.dart';
import 'package:meta/meta.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit(this._userRepository) : super(UserInitial());

  final UserRepository _userRepository;
}
