import 'package:mocktail/mocktail.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:pocketbase_helpers/pocketbase_helpers.dart';
import 'package:test/test.dart';

import '../utils/utils.dart';

void mockAuthWithPassword(MockRecordService service, RecordAuth response) {
  when(
    () => service.authWithPassword(
      any(),
      any(),
      expand: any(named: 'expand'),
      query: any(named: 'query'),
      headers: any(named: 'headers'),
    ),
  ).thenAnswer((_) async => response);
}

void mockIncorrectCredentials(MockRecordService service) {
  when(
    () => service.authWithPassword(
      any(),
      any(),
      expand: any(named: 'expand'),
      query: any(named: 'query'),
      headers: any(named: 'headers'),
    ),
  ).thenAnswer((_) async => throw ClientException(statusCode: 400));
}

void mockServerError(MockRecordService service) {
  when(
    () => service.authWithPassword(
      any(),
      any(),
      expand: any(named: 'expand'),
      query: any(named: 'query'),
      headers: any(named: 'headers'),
    ),
  ).thenAnswer((_) async => throw ClientException(statusCode: 500));
}

void mockTooManyOtpRequests(MockRecordService service) {
  when(
    () => service.requestOTP(
      any(),
      body: any(named: 'body'),
      query: any(named: 'query'),
      headers: any(named: 'headers'),
    ),
  ).thenAnswer((_) async => throw ClientException(statusCode: 429));
}

void mockAuthWithOAuth2(MockRecordService service, RecordAuth response) {
  when(
    () => service.authWithOAuth2(
      any(),
      any(),
      expand: any(named: 'expand'),
      query: any(named: 'query'),
      headers: any(named: 'headers'),
    ),
  ).thenAnswer((_) async => response);
}

void mockAuthWithOTP(MockRecordService service, RecordAuth response) {
  when(
    () => service.authWithOTP(
      any(),
      any(),
      expand: any(named: 'expand'),
      query: any(named: 'query'),
      headers: any(named: 'headers'),
    ),
  ).thenAnswer((_) async => response);
}

void mockRequestOTP(MockRecordService service, OTPResponse response) {
  when(
    () => service.requestOTP(
      any(),
      query: any(named: 'query'),
      headers: any(named: 'headers'),
    ),
  ).thenAnswer((_) async => response);
}

void mockRequestVerification(MockRecordService service) {
  return when(
    () => service.requestVerification(
      any(),
      query: any(named: 'query'),
      headers: any(named: 'headers'),
    ),
  ).thenAnswer((_) async => true);
}

void mockConfirmPasswordReset(MockRecordService service) {
  return when(
    () => service.confirmPasswordReset(
      any(),
      any(),
      any(),
      query: any(named: 'query'),
      headers: any(named: 'headers'),
    ),
  ).thenAnswer((_) async => true);
}

void mockRequestPasswordReset(MockRecordService service) {
  when(
    () => service.requestPasswordReset(
      any(),
      query: any(named: 'query'),
      headers: any(named: 'headers'),
    ),
  ).thenAnswer((_) async => true);
}

void mockConfirmVerification(MockRecordService service) {
  when(
    () => service.confirmVerification(
      any(),
      query: any(named: 'query'),
      headers: any(named: 'headers'),
    ),
  ).thenAnswer((_) async => true);
}

void mockAuthRefresh(MockRecordService service, RecordAuth response) {
  when(
    () => service.authRefresh(
      expand: any(named: 'expand'),
      fields: any(named: 'fields'),
      query: any(named: 'query'),
      headers: any(named: 'headers'),
    ),
  ).thenAnswer((_) async => response);
}

void main() {
  late MockPocketBase pb;
  late MockRecordService service;
  late AuthHelper<DummyRecord> authHelper;

  setUp(() {
    (pb, service) = setupRecordMocks();
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
      final authData = RecordAuth(token: 'TOKEN', record: model);

      mockAuthWithPassword(service, authData);

      final result = await authHelper.withPassword(
        'test@example.com',
        'password',
      );

      expect(result.status, equals(AuthStatus.ok));
      expect(result.token, 'TOKEN');
      expectRecord(result.record, expected);
    });

    test('withPassword returns incorrectCredentials on 400 error', () async {
      mockIncorrectCredentials(service);

      final result = await authHelper.withPassword('user', 'pass');

      expect(result.status, equals(AuthStatus.incorrectCredentials));
      expect(result.token, isNull);
      expect(result.record, isNull);
    });

    test('withPassword returns server error', () async {
      mockServerError(service);

      final result = await authHelper.withPassword('user', 'pass');

      expect(result.status, equals(AuthStatus.serverError));
      expect(result.token, isNull);
      expect(result.record, isNull);
    });

    test('withOAuth2 returns ok and mapped record on success', () async {
      final (model, expected) = DummyRecord.randomModel();
      final authData = RecordAuth(token: 'TOKEN', record: model);

      mockAuthWithOAuth2(service, authData);

      final result = await authHelper.withOAuth2(
        'google',
        urlCallback: (url) {},
      );

      expect(result.status, equals(AuthStatus.ok));
      expect(result.token, 'TOKEN');
      expectRecord(result.record, expected);
    });

    test('withOTP returns ok and mapped record on success', () async {
      final (model, expected) = DummyRecord.randomModel();
      final authData = RecordAuth(token: 'TOKEN', record: model);

      mockAuthWithOTP(service, authData);

      final result = await authHelper.withOTP('otpId', 'code');

      expect(result.status, equals(AuthStatus.ok));
      expect(result.token, 'TOKEN');
      expectRecord(result.record, expected);
    });

    test('requestOTP returns ok and otpId on success', () async {
      mockRequestOTP(service, OTPResponse(otpId: 'test-otp-id'));

      final result = await authHelper.requestOTP('test@example.com');

      expect(result.status, equals(AuthStatus.ok));
      expect(result.otpId, equals('test-otp-id'));
    });

    test('requestOTP return too many otp requests on failure', () async {
      mockTooManyOtpRequests(service);

      final result = await authHelper.requestOTP('test@example.com');

      expect(result.status, equals(AuthStatus.tooManyOtpRequests));
      expect(result.otpId, isNull);
    });

    test('requestVerification returns ok on success', () async {
      mockRequestVerification(service);

      final result = await authHelper.requestVerification('test@example.com');

      expect(result, equals(AuthStatus.ok));
    });

    test('confirmVerification returns ok on success', () async {
      mockConfirmVerification(service);

      final result = await authHelper.confirmVerification('token');

      expect(result, equals(AuthStatus.ok));
    });

    test('requestPasswordReset returns ok on success', () async {
      mockRequestPasswordReset(service);

      final result = await authHelper.requestPasswordReset('test@example.com');

      expect(result, equals(AuthStatus.ok));
    });

    test('confirmPasswordReset returns ok on success', () async {
      mockConfirmPasswordReset(service);

      final result = await authHelper.confirmPasswordReset(
        'token',
        'pass',
        'pass',
      );

      expect(result, equals(AuthStatus.ok));
    });

    test('auth refresh returns ok with record on succes', () async {
      final (model, expected) = DummyRecord.randomModel();

      mockAuthRefresh(service, RecordAuth(token: 'TOKEN', record: model));

      final result = await authHelper.refresh();

      expect(result.status, equals(AuthStatus.ok));
      expect(result.token, 'TOKEN');
      expectRecord(result.record, expected);
    });
  });
}
