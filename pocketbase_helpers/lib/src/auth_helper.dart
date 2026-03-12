import 'package:pocketbase/pocketbase.dart';
import 'package:pocketbase_helpers/src/helper_utils.dart';
import 'package:pocketbase_helpers/src/pocketbase_connection.dart';
import 'package:pocketbase_helpers/src/shared.dart';

/// The final result from an authentication flow, if [status] is ok, the authenticated record is
/// provided through [record].
typedef RecordAuthResult<T> = ({AuthStatus status, T? record});

/// The result from an otp request, if [status] is ok, the otpId is provided through [otpId].
typedef OTPAuthResult = ({AuthStatus status, String? otpId});

/// A helper to do authentication operations on a collection.
class AuthHelper<T extends Object> {
  /// A helper to do authentication operations on a collection.
  const AuthHelper({
    required this.collection,
    required RecordMapper<T> mapper,
    PocketBase? pocketBaseInstance,
    Map<String, String>? expansions,
  }) : _pb = pocketBaseInstance,
       _mapper = mapper,
       _expansions = expansions;

  final PocketBase? _pb;
  PocketBase get pb => _pb ?? PocketBaseConnection.pb;
  final RecordMapper<T> _mapper;
  final Map<String, String>? _expansions;

  /// The collection this helper is operating on.
  final String collection;

  Map<String, String> _combineExp(Map<String, String>? additionalExpansions) =>
      (_expansions ?? {})..addAll(additionalExpansions ?? const {});

  /// Authenticate a record with email/username and password.
  Future<RecordAuthResult<T>> withPassword(
    String email,
    String password, {
    Map<String, String>? additionalExpansions,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    try {
      final expansions = _combineExp(additionalExpansions);

      final result = await pb
          .collection(collection)
          .authWithPassword(
            email,
            password,
            expand: HelperUtils.buildExpansionString(expansions),
            query: query ?? const {},
            headers: headers ?? const {},
          );

      return (
        status: AuthStatus.ok,
        record: _mapper(
          HelperUtils.mergeExpansions(
            expansions,
            result.record.toJson(),
          ).clean(),
        ),
      );
    } catch (e) {
      return (status: _authCatch(e), record: null);
    }
  }

  /// Authenticate a record with OAuth2.
  Future<RecordAuthResult<T>> withOAuth2(
    String provider, {
    required void Function(Uri url) urlCallback,
    Map<String, String>? additionalExpansions,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    try {
      final expansions = _combineExp(additionalExpansions);

      final result = await pb
          .collection(collection)
          .authWithOAuth2(
            provider,
            urlCallback,
            expand: HelperUtils.buildExpansionString(expansions),
            query: query ?? const {},
            headers: headers ?? const {},
          );

      return (
        status: AuthStatus.ok,
        record: _mapper(
          HelperUtils.mergeExpansions(
            expansions,
            result.record.toJson(),
          ).clean(),
        ),
      );
    } catch (e) {
      return (status: _authCatch(e), record: null);
    }
  }

  /// Authenticate a record with OTP.
  Future<RecordAuthResult<T>> withOTP(
    String otpId,
    String code, {
    Map<String, String>? additionalExpansions,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    try {
      final expansions = _combineExp(additionalExpansions);
      final result = await pb
          .collection(collection)
          .authWithOTP(
            otpId,
            code,
            expand: HelperUtils.buildExpansionString(expansions),
            query: query ?? const {},
            headers: headers ?? const {},
          );

      return (
        status: AuthStatus.ok,
        record: _mapper(
          HelperUtils.mergeExpansions(
            expansions,
            result.record.toJson(),
          ).clean(),
        ),
      );
    } catch (e) {
      return (status: _authCatch(e), record: null);
    }
  }

  /// Request OTP for a specific email.
  Future<OTPAuthResult> requestOTP(
    String email, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await pb
          .collection(collection)
          .requestOTP(
            email,
            query: query ?? const {},
            headers: headers ?? const {},
          );
      return (status: AuthStatus.ok, otpId: response.otpId);
    } catch (e) {
      return (status: _authCatch(e), otpId: null);
    }
  }

  /// Request a verification email.
  Future<AuthStatus> requestVerification(
    String email, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    try {
      await pb
          .collection(collection)
          .requestVerification(
            email,
            query: query ?? const {},
            headers: headers ?? const {},
          );
      return AuthStatus.ok;
    } catch (e) {
      return _authCatch(e);
    }
  }

  /// Confirm a verification request.
  Future<AuthStatus> confirmVerification(
    String token, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    try {
      await pb
          .collection(collection)
          .confirmVerification(
            token,
            query: query ?? const {},
            headers: headers ?? const {},
          );
      return AuthStatus.ok;
    } catch (e) {
      return _authCatch(e);
    }
  }

  /// Request a password reset email.
  Future<AuthStatus> requestPasswordReset(
    String email, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    try {
      await pb
          .collection(collection)
          .requestPasswordReset(
            email,
            query: query ?? const {},
            headers: headers ?? const {},
          );
      return AuthStatus.ok;
    } catch (e) {
      return _authCatch(e);
    }
  }

  /// Confirm a password reset request.
  Future<AuthStatus> confirmPasswordReset(
    String token,
    String password,
    String passwordConfirm, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    try {
      await pb
          .collection(collection)
          .confirmPasswordReset(
            token,
            password,
            passwordConfirm,
            query: query ?? const {},
            headers: headers ?? const {},
          );
      return AuthStatus.ok;
    } catch (e) {
      return _authCatch(e);
    }
  }

  AuthStatus _authCatch(Object e) {
    if (e is ClientException) {
      if (e.statusCode == 400 || e.statusCode == 404) {
        return AuthStatus.incorrectCredentials;
      }
      if (e.statusCode == 429) {
        return AuthStatus.tooManyOtpRequests;
      }
    }
    return AuthStatus.serverError;
  }
}

extension _MapClean on Map<String, dynamic> {
  Map<String, dynamic> clean() {
    return HelperUtils.cleanMap(this);
  }
}
