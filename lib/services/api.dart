import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jsonica/models/models.dart';

/// Exception thrown when fetchListUser fails.
class UsersRequestFailure implements Exception {}

/// Exception thrown when users is empty.
class UsersIsEmpty implements Exception {}

class UsersIsNotAList implements Exception {}

class Api {
  Api({http.Client? httpClient}) : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  static const _baseUrl = 'jsonplaceholder.typicode.com';

  Future<List<User>> fetchUsers() async {
    final userListUrl = Uri.https(
      _baseUrl,
      '/users',
    );

    final usersResponse = await _httpClient.get(userListUrl);

    if (usersResponse.statusCode != 200) {
      throw UsersRequestFailure();
    }

    final rawUsers = jsonDecode(usersResponse.body) as List;

    if (rawUsers.isEmpty) {
      throw UsersIsEmpty();
    }

    return rawUsers.map((e) => User.fromJson(e)).toList();
  }
}
