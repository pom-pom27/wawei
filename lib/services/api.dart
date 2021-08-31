import 'dart:convert';

import 'package:http/http.dart' as http;

import 'models/models.dart';

/// Exception thrown when fetchListUser fails.
class UsersRequestFailure implements Exception {}

/// Exception thrown when users is empty.
class UsersIsEmpty implements Exception {}

class UsersIsNotAList implements Exception {}

class Api {
  Api({http.Client? httpClient}) : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  static const _baseUrl = 'jsonplaceholder.typicode.com';

  Future<RawUser> fetchUser({required int id}) async {
    final userUrl = Uri.https(
      _baseUrl,
      '/users/$id',
    );

    final userResponse = await _httpClient.get(userUrl);

    if (userResponse.statusCode != 200) {
      throw UsersRequestFailure();
    }

    final decodedJson = jsonDecode(userResponse.body);
    return RawUser.fromJson(decodedJson);
  }

  Future<List<RawUser>> fetchUsers() async {
    final userListUrl = Uri.https(
      _baseUrl,
      '/users',
    );

    final usersResponse = await _httpClient.get(userListUrl);

    if (usersResponse.statusCode != 200) {
      throw UsersRequestFailure();
    }

    final decodedJson = jsonDecode(usersResponse.body) as List;

    if (decodedJson.isEmpty) {
      throw UsersIsEmpty();
    }

    final rawUsers = decodedJson.map((e) => RawUser.fromJson(e)).toList();

    return rawUsers;
  }
}
