import 'models/models.dart';
import '../services/services.dart';

class UserFailure implements Exception {}

class UserRepository {
  final Api _api;

  UserRepository({Api? api}) : _api = api ?? Api();

  Future<User> getUser({required int id}) async {
    final rawUser = await _api.fetchUser(id: id);

    return User(
      email: rawUser.email,
      name: rawUser.name,
      phone: rawUser.phone,
      website: rawUser.website,
    );
  }

  Future<List<User>> getUsers() async {
    final rawUsers = await _api.fetchUsers();

    final list = rawUsers
        .map((rawUser) => User(
              email: rawUser.email,
              name: rawUser.name,
              phone: rawUser.phone,
              website: rawUser.website,
            ))
        .toList();

    return list;
  }
}
