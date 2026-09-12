import 'package:mocktail/mocktail.dart';
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
    test('withPassword returns mapped record on success', () async {
      final (model, expected) = DummyRecord.randomModel();
      final authData = RecordAuth(token: 'TOKEN', record: model);

      mockAuthWithPassword(service, authData);

      final record = await authHelper.withPassword('test@example.com', 'password');

      expectRecord(record, expected);
    });

    test('withOAuth2 returns mapped record on success', () async {
      final (model, expected) = DummyRecord.randomModel();
      final authData = RecordAuth(token: 'TOKEN', record: model);

      mockAuthWithOAuth2(service, authData);

      final record = await authHelper.withOAuth2('google', urlCallback: (url) {});

      expectRecord(record, expected);
    });

    test('withOTP returns mapped record on success', () async {
      final (model, expected) = DummyRecord.randomModel();
      final authData = RecordAuth(token: 'TOKEN', record: model);

      mockAuthWithOTP(service, authData);

      final record = await authHelper.withOTP('otpId', 'code');

      expectRecord(record, expected);
    });

    test('requestOTP returns otpId on success', () async {
      mockRequestOTP(service, OTPResponse(otpId: 'test-otp-id'));

      final otpId = await authHelper.requestOTP('test@example.com');

      expect(otpId, equals('test-otp-id'));
    });

    test('refresh returns mapped record on success', () async {
      final (model, expected) = DummyRecord.randomModel();

      mockAuthRefresh(service, RecordAuth(token: 'TOKEN', record: model));

      final record = await authHelper.refresh();

      expectRecord(record, expected);
    });
  });
}
