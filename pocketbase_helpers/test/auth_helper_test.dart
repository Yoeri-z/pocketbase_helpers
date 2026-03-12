import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:pocketbase_helpers/pocketbase_helpers.dart';
import 'package:test/test.dart';

import 'setup.dart';

void main() {
  late MockPocketBase pb;
  late MockRecordService service;
  late AuthHelper<DummyRecord> authHelper;

  setUp(() {
    pb = MockPocketBase();
    service = MockRecordService();
    when(() => pb.collection(any())).thenReturn(service);
    authHelper = AuthHelper(
      pocketBaseInstance: pb,
      collection: 'dummy',
      mapper: DummyRecord.fromMap,
      expansions: DummyRecord.expansions,
    );
  });

  group('AuthHelper', () {
    test('withPassword returns ok and mapped record on success', () async {
      final (model, expected) = DummyRecord.randomModel();
      final authData = RecordAuth(token: 'token', record: model);

      when(
        () => service.authWithPassword(
          'test@example.com',
          'password',
          expand: any(named: 'expand'),
          query: any(named: 'query'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => authData);

      final result = await authHelper.withPassword(
        'test@example.com',
        'password',
      );

      expect(result, equals(AuthStatus.ok));
      expect(result.record?.id, equals(expected.id));
    });

    test('withPassword returns incorrectCredentials on 400 error', () async {
      when(
        () => service.authWithPassword(
          any(),
          any(),
          expand: any(named: 'expand'),
          query: any(named: 'query'),
          headers: any(named: 'headers'),
        ),
      ).thenThrow(ClientException(statusCode: 400));

      final result = await authHelper.withPassword('user', 'pass');

      expect(result.status, equals(AuthStatus.incorrectCredentials));
      expect(result.record, isNull);
    });

    test('withOAuth2 returns ok and mapped record on success', () async {
      final (model, expected) = DummyRecord.randomModel();
      final authData = RecordAuth(token: 'token', record: model);

      when(
        () => service.authWithOAuth2(
          any(),
          any(),
          expand: any(named: 'expand'),
          query: any(named: 'query'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => authData);

      final result = await authHelper.withOAuth2(
        'google',
        urlCallback: (url) {},
      );

      expect(result.status, equals(AuthStatus.ok));
      expect(result.record?.id, equals(expected.id));
    });

    test('withOTP returns ok and mapped record on success', () async {
      final (model, expected) = DummyRecord.randomModel();
      final authData = RecordAuth(token: 'token', record: model);

      when(
        () => service.authWithOTP(
          any(),
          any(),
          expand: any(named: 'expand'),
          query: any(named: 'query'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => authData);

      final result = await authHelper.withOTP('otpId', 'code');

      expect(result.status, equals(AuthStatus.ok));
      expect(result.record?.id, equals(expected.id));
    });

    test('requestOTP returns ok and otpId on success', () async {
      when(
        () => service.requestOTP(
          any(),
          query: any(named: 'query'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => OTPResponse(otpId: 'test-otp-id'));

      final result = await authHelper.requestOTP('test@example.com');

      expect(result.status, equals(AuthStatus.ok));
      expect(result.otpId, equals('test-otp-id'));
    });

    test('requestVerification returns ok on success', () async {
      when(
        () => service.requestVerification(
          any(),
          query: any(named: 'query'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => true);

      final result = await authHelper.requestVerification('test@example.com');

      expect(result, equals(AuthStatus.ok));
    });

    test('confirmVerification returns ok on success', () async {
      when(
        () => service.confirmVerification(
          any(),
          query: any(named: 'query'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => true);

      final result = await authHelper.confirmVerification('token');

      expect(result, equals(AuthStatus.ok));
    });

    test('requestPasswordReset returns ok on success', () async {
      when(
        () => service.requestPasswordReset(
          any(),
          query: any(named: 'query'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => true);

      final result = await authHelper.requestPasswordReset('test@example.com');

      expect(result, equals(AuthStatus.ok));
    });

    test('confirmPasswordReset returns ok on success', () async {
      when(
        () => service.confirmPasswordReset(
          any(),
          any(),
          any(),
          query: any(named: 'query'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => true);

      final result = await authHelper.confirmPasswordReset(
        'token',
        'pass',
        'pass',
      );

      expect(result, equals(AuthStatus.ok));
    });

    test('_authCatch handles 429 tooManyOtpRequests', () async {
      when(
        () => service.requestOTP(
          any(),
          query: any(named: 'query'),
          headers: any(named: 'headers'),
        ),
      ).thenThrow(ClientException(statusCode: 429));

      final result = await authHelper.requestOTP('test@example.com');

      expect(result.status, equals(AuthStatus.tooManyOtpRequests));
      expect(result.otpId, isNull);
    });
  });
}
