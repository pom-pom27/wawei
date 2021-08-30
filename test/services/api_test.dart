import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:jsonica/services/services.dart';
import 'package:mocktail/mocktail.dart';

class MockHttpsClient extends Mock implements http.Client {}

class MockResponsesClient extends Mock implements http.Response {}

class FakeUriClient extends Fake implements Uri {}

void main() {
  late http.Client httpClient;

  late Api api;

  setUpAll(() {
    registerFallbackValue<Uri>(FakeUriClient());
  });

  setUp(() {
    httpClient = MockHttpsClient();
    api = Api(httpClient: httpClient);
  });

  group('constructor -', () {
    test('does not require a httpClient', () {
      expect(Api(), isNotNull);
    });
  });

  group('fetchUsers -', () {
    test('make correct http request', () async {
      final response = MockResponsesClient();

      when(() => response.statusCode).thenReturn(200);
      when(() => response.body).thenReturn('{}');

      when(() => httpClient.get(any()))
          .thenAnswer((invocation) async => response);

      try {
        await api.fetchUsers();
      } catch (_) {}

      verify(() => httpClient
          .get(Uri.https('jsonplaceholder.typicode.com', '/users'))).called(1);
    });

    test('throws an UsersRequestFailure on non-200 statusCode response', () {
      final response = MockResponsesClient();

      when(() => response.statusCode).thenReturn(404);

      // when(() => response.body).thenReturn('{}');

      when(() => httpClient.get(any())).thenAnswer((_) async => response);

      expect(() async => await api.fetchUsers(),
          throwsA(isA<UsersRequestFailure>()));
    });

    test('throws an UsersEmptyFailure on empty response', () async {
      final response = MockResponsesClient();

      when(() => response.statusCode).thenReturn(200);

      when(() => response.body).thenReturn('[]');

      when(() => httpClient.get(any())).thenAnswer((_) async => response);

      expect(() async => await api.fetchUsers(), throwsA(isA<UsersIsEmpty>()));
    });
    test('throws an TypeError on non list users response', () async {
      final response = MockResponsesClient();

      when(() => response.statusCode).thenReturn(200);

      when(() => response.body).thenReturn('{}');

      when(() => httpClient.get(any())).thenAnswer((_) async => response);

      expect(() async => await api.fetchUsers(), throwsA(isA<TypeError>()));
    });
  });
}
