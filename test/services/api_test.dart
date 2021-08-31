import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:jsonica/services/models/models.dart';
import 'package:jsonica/services/services.dart';
import 'package:mocktail/mocktail.dart';

//Data layer Test Mock
// -http
// -http.Response
// -Uri

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

    test('return users on valid response', () async {
      final response = MockResponsesClient();

      when(() => response.statusCode).thenReturn(200);
      when(() => response.body).thenReturn(
          '''[
   {
      "id":1,
      "name":"Leanne Graham",
      "username":"Bret",
      "email":"Sincere@april.biz",
      "address":{
         "street":"Kulas Light",
         "suite":"Apt. 556",
         "city":"Gwenborough",
         "zipcode":"92998-3874",
         "geo":{
            "lat":"-37.3159",
            "lng":"81.1496"
         }
      },
      "phone":"1-770-736-8031 x56442",
      "website":"hildegard.org",
      "company":{
         "name":"Romaguera-Crona",
         "catchPhrase":"Multi-layered client-server neural-net",
         "bs":"harness real-time e-markets"
      }
   },
   {
      "id":2,
      "name":"Ervin Howell",
      "username":"Antonette",
      "email":"Shanna@melissa.tv",
      "address":{
         "street":"Victor Plains",
         "suite":"Suite 879",
         "city":"Wisokyburgh",
         "zipcode":"90566-7771",
         "geo":{
            "lat":"-43.9509",
            "lng":"-34.4618"
         }
      },
      "phone":"010-692-6593 x09125",
      "website":"anastasia.net",
      "company":{
         "name":"Deckow-Crist",
         "catchPhrase":"Proactive didactic contingency",
         "bs":"synergize scalable supply-chains"
      }
   }
]''');
      when(() => httpClient.get(any())).thenAnswer((_) async => response);

      final actual = await api.fetchUsers();

      expect(
        actual,
        isA<List<RawUser>>()
            .having((user) => user[0].id, 'id', 1)
            .having((user) => user[0].name, 'name', 'Leanne Graham')
            .having((user) => user[0].username, 'username', 'Bret')
            .having((user) => user[0].email, 'email', 'Sincere@april.biz')
            .having((user) => user[0].address!.city, 'city', 'Gwenborough'),
      );
    });
  });

  group('fetchUser -', () {
    test('make correct http request', () async {
      final response = MockResponsesClient();

      when(() => response.statusCode).thenReturn(200);
      when(() => response.body).thenReturn('{}');

      when(() => httpClient.get(any()))
          .thenAnswer((invocation) async => response);

      try {
        await api.fetchUser(id: 2);
      } catch (_) {}

      verify(() => httpClient.get(
          Uri.https('jsonplaceholder.typicode.com', '/users/2'))).called(1);
    });

    test('throws an UsersRequestFailure on non-200 statusCode response', () {
      final response = MockResponsesClient();

      when(() => response.statusCode).thenReturn(404);

      // when(() => response.body).thenReturn('{}');

      when(() => httpClient.get(any())).thenAnswer((_) async => response);

      expect(() async => await api.fetchUser(id: 2),
          throwsA(isA<UsersRequestFailure>()));
    });

    test('return users on valid response', () async {
      final response = MockResponsesClient();

      when(() => response.statusCode).thenReturn(200);
      when(() => response.body).thenReturn(
          '''{
   "id":2,
   "name":"Ervin Howell",
   "username":"Antonette",
   "email":"Shanna@melissa.tv",
   "address":{
      "street":"Victor Plains",
      "suite":"Suite 879",
      "city":"Wisokyburgh",
      "zipcode":"90566-7771",
      "geo":{
         "lat":"-43.9509",
         "lng":"-34.4618"
      }
   },
   "phone":"010-692-6593 x09125",
   "website":"anastasia.net",
   "company":{
      "name":"Deckow-Crist",
      "catchPhrase":"Proactive didactic contingency",
      "bs":"synergize scalable supply-chains"
   }
}''');
      when(() => httpClient.get(any())).thenAnswer((_) async => response);

      final actual = await api.fetchUser(id: 2);

      expect(
        actual,
        isA<RawUser>()
            .having((user) => user.id, 'id', 2)
            .having((user) => user.name, 'name', 'Ervin Howell')
            .having((user) => user.username, 'username', 'Antonette')
            .having((user) => user.email, 'email', 'Shanna@melissa.tv')
            .having((user) => user.address!.city, 'city', 'Wisokyburgh'),
      );
    });
  });
}
