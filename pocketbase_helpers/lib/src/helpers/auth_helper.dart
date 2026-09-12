import 'package:pocketbase/pocketbase.dart';
import 'package:pocketbase_helpers/src/helper_utils.dart';
import 'package:pocketbase_helpers/src/pocketbase_connection.dart';
import 'package:pocketbase_helpers/src/shared.dart';

/// A helper to do authentication operations on a collection.
///
/// The methods behave like their counterparts on the [RecordService]: they
/// return the authentication data (or throw) instead of catching errors.
class AuthHelper<T extends Object> {
  /// A helper to do authentication operations on a collection.
  const AuthHelper({
    required this.collection,
    required RecordMapper<T> mapper,
    PocketBase? pocketBaseInstance,
    List<String>? fields,
    Map<String, String>? expansions,
  }) : _pb = pocketBaseInstance,
       _fields = fields,
       _mapper = mapper,
       _expansions = expansions;

  final PocketBase? _pb;

  /// The [PocketBase] instance this helper is using.
  PocketBase get pb => _pb ?? PocketBaseConnection.pb;
  final RecordMapper<T> _mapper;
  final Map<String, String>? _expansions;

  final List<String>? _fields;

  /// The collection this helper is operating on.
  final String collection;

  /// Authenticate a record with email/username and password.
  Future<T> withPassword(
    String email,
    String password, {
    Map<String, String>? additionalExpansions,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    final result = await pb.collection(collection).authWithPassword(
          email,
          password,
          fields: _fields?.join(','),
          expand: HelperUtils.buildExpansionString(_expansions),
          query: query ?? const {},
          headers: headers ?? const {},
        );

    return _mapper(HelperUtils.getRecordJson(result.record, _expansions));
  }

  /// Authenticate a record with OAuth2.
  Future<T> withOAuth2(
    String provider, {
    required void Function(Uri url) urlCallback,
    List<String> scopes = const [],
    Map<String, dynamic> createData = const {},
    Map<String, dynamic> query = const {},
    Map<String, String> headers = const {},
  }) async {
    final result = await pb.collection(collection).authWithOAuth2(
      provider,
      urlCallback,
      scopes: scopes,
      createData: createData,
      fields: _fields?.join(','),
      expand: HelperUtils.buildExpansionString(_expansions),
      query: query,
      headers: headers,
    );

    return _mapper(HelperUtils.getRecordJson(result.record, _expansions));
  }

  /// Authenticate a record with OTP.
  Future<T> withOTP(
    String otpId,
    String code, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    final result = await pb.collection(collection).authWithOTP(
      otpId,
      code,
      fields: _fields?.join(','),
      expand: HelperUtils.buildExpansionString(_expansions),
      query: query ?? const {},
      headers: headers ?? const {},
    );

    return _mapper(HelperUtils.getRecordJson(result.record, _expansions));
  }

  /// Request OTP for a specific email, returns the otp id.
  Future<String> requestOTP(
    String email, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) {
    return pb
        .collection(collection)
        .requestOTP(
          email,
          query: query ?? const {},
          headers: headers ?? const {},
        )
        .then((response) => response.otpId);
  }

  /// Request a verification email.
  Future<void> requestVerification(
    String email, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) {
    return pb
        .collection(collection)
        .requestVerification(
          email,
          query: query ?? const {},
          headers: headers ?? const {},
        );
  }

  /// Confirm a verification request.
  Future<void> confirmVerification(
    String token, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) {
    return pb
        .collection(collection)
        .confirmVerification(
          token,
          query: query ?? const {},
          headers: headers ?? const {},
        );
  }

  /// Request a password reset email.
  Future<void> requestPasswordReset(
    String email, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) {
    return pb
        .collection(collection)
        .requestPasswordReset(
          email,
          query: query ?? const {},
          headers: headers ?? const {},
        );
  }

  /// Confirm a password reset request.
  Future<void> confirmPasswordReset(
    String token,
    String password,
    String passwordConfirm, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) {
    return pb
        .collection(collection)
        .confirmPasswordReset(
          token,
          password,
          passwordConfirm,
          query: query ?? const {},
          headers: headers ?? const {},
        );
  }

  /// Refresh the token of the authenticated record currently registered in [pb].
  Future<T> refresh({
    Map<String, dynamic>? body,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    final result = await pb.collection(collection).authRefresh(
      expand: HelperUtils.buildExpansionString(_expansions),
      fields: _fields?.join(','),
      body: body ?? const {},
      query: query ?? const {},
      headers: headers ?? const {},
    );

    return _mapper(HelperUtils.getRecordJson(result.record, _expansions));
  }
}
