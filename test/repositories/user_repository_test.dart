import 'package:flutter_test/flutter_test.dart';
import 'package:jsonica/repositories/models/user/user.dart';
import 'package:jsonica/repositories/user_repository.dart';
import 'package:jsonica/services/models/models.dart';
import 'package:jsonica/services/services.dart';
import 'package:mocktail/mocktail.dart';

// Repository Testing ORDER:
//   -Mocking
//   -Setup
//   -Testing

// Repository Testing Mock:
// -Api
// -RawModel

class RawUserMock extends Mock implements RawUser {}

class MockUserApi extends Mock implements Api {}

void main() {
  //init var repository
  // - Api
  // - repository

  late Api api;
  late UserRepository userRepository;

  setUp(() {
    api = MockUserApi();
    userRepository = UserRepository(api: api);
  });

  test('instantiates internal api when not injected', () {
    expect(UserRepository(), isNotNull);
  });

  group('getUser -', () {
    const id = 2;

    test('calls fetchUser with correct id', () async {
      try {
        await userRepository.getUser(id: id);
      } catch (e) {}

      verify(() => api.fetchUser(id: id)).called(1);
    });

    test('throw exception when fetchUser fail', () {
      final exception = Exception('oops');
      when(() => api.fetchUser(id: id)).thenThrow(exception);

      expect(() async => userRepository.getUser(id: id), throwsA(exception));
    });

    test('return correct user on success', () async {
      final rawUser = RawUserMock();

      when(() => rawUser.email).thenReturn('Shanna@melissa.tv');
      when(() => rawUser.name).thenReturn('Ervin Howell');
      when(() => rawUser.phone).thenReturn('010-692-6593 x09125');
      when(() => rawUser.website).thenReturn('anastasia.net');

      when(() => api.fetchUser(id: id))
          .thenAnswer((invocation) async => rawUser);

      final actual = await userRepository.getUser(id: id);
      expect(
          actual,
          User(
            email: 'Shanna@melissa.tv',
            name: 'Ervin Howell',
            phone: '010-692-6593 x09125',
            website: 'anastasia.net',
          ));
    });
  });
}
