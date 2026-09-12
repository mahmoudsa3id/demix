import 'app_failure.dart';

class FailureMessageResolver {
  FailureMessageResolver._();

  static String resolve(AppFailure failure, String languageCode) {
    final messages = languageCode.toLowerCase().startsWith('ar')
        ? _arabic
        : _english;

    return messages[failure.message] ?? messages['errors.unknown']!;
  }

  // ===========================================================================
  // English
  // ===========================================================================

  static const Map<String, String> _english = {
    'auth.invalidEmail': 'The email address is invalid.',

    'auth.weakPassword': 'The password is too weak.',

    'auth.emailAlreadyInUse': 'This email address is already in use.',

    'auth.userNotFound': 'No account was found with this email.',

    'auth.invalidCredentials': 'The email or password is incorrect.',

    'auth.userDisabled': 'This account has been disabled.',

    'auth.requiresRecentLogin':
        'Please sign in again to complete this operation.',

    'auth.sessionExpired': 'Your session has expired. Please sign in again.',

    'auth.operationNotAllowed': 'This authentication method is not enabled.',

    'auth.accountExistsWithDifferentCredential':
        'An account already exists with this email using a different sign-in method.',

    'auth.credentialAlreadyInUse':
        'This credential is already associated with another account.',

    'auth.popupBlocked': 'The sign-in popup was blocked.',

    'auth.invalidVerificationCode': 'The verification code is invalid.',

    'auth.invalidVerificationId': 'The verification ID is invalid.',

    'auth.authenticationFailed': 'Authentication failed. Please try again.',

    'errors.network': 'Please check your internet connection.',

    'errors.timeout': 'The request timed out. Please try again.',

    'errors.permissionDenied':
        'You do not have permission to perform this operation.',

    'errors.unauthenticated': 'You need to sign in first.',

    'errors.notFound': 'The requested item was not found.',

    'errors.tooManyRequests': 'Too many requests. Please try again later.',

    'errors.resourceExhausted': 'The request limit has been exceeded.',

    'errors.invalidData': 'The provided data is invalid.',

    'errors.alreadyExists': 'This item already exists.',

    'errors.server': 'A server error occurred. Please try again.',

    'errors.cancelled': 'The operation was cancelled.',

    'errors.unknown': 'An unexpected error occurred. Please try again.',
  };

  // ===========================================================================
  // Arabic
  // ===========================================================================

  static const Map<String, String> _arabic = {
    'auth.invalidEmail': 'البريد الإلكتروني غير صالح.',

    'auth.weakPassword': 'كلمة المرور ضعيفة.',

    'auth.emailAlreadyInUse': 'البريد الإلكتروني مستخدم بالفعل.',

    'auth.userNotFound': 'لا يوجد حساب بهذا البريد الإلكتروني.',

    'auth.invalidCredentials': 'البريد الإلكتروني أو كلمة المرور غير صحيحة.',

    'auth.userDisabled': 'تم تعطيل هذا الحساب.',

    'auth.requiresRecentLogin':
        'يرجى تسجيل الدخول مرة أخرى لإتمام هذه العملية.',

    'auth.sessionExpired':
        'انتهت جلسة تسجيل الدخول. يرجى تسجيل الدخول مرة أخرى.',

    'auth.operationNotAllowed': 'طريقة تسجيل الدخول هذه غير مفعلة.',

    'auth.accountExistsWithDifferentCredential':
        'يوجد حساب بهذا البريد باستخدام طريقة تسجيل دخول مختلفة.',

    'auth.credentialAlreadyInUse':
        'بيانات تسجيل الدخول هذه مرتبطة بحساب آخر بالفعل.',

    'auth.popupBlocked': 'تم حظر نافذة تسجيل الدخول.',

    'auth.invalidVerificationCode': 'رمز التحقق غير صحيح.',

    'auth.invalidVerificationId': 'رمز التحقق غير صالح.',

    'auth.authenticationFailed': 'فشل تسجيل الدخول. حاول مرة أخرى.',

    'errors.network': 'يرجى التحقق من اتصالك بالإنترنت.',

    'errors.timeout': 'انتهت مهلة الطلب. حاول مرة أخرى.',

    'errors.permissionDenied': 'ليس لديك صلاحية لتنفيذ هذه العملية.',

    'errors.unauthenticated': 'يجب تسجيل الدخول أولًا.',

    'errors.notFound': 'العنصر المطلوب غير موجود.',

    'errors.tooManyRequests': 'تم إجراء محاولات كثيرة. حاول مرة أخرى لاحقًا.',

    'errors.resourceExhausted': 'تم تجاوز الحد المسموح من الطلبات.',

    'errors.invalidData': 'البيانات المرسلة غير صحيحة.',

    'errors.alreadyExists': 'هذا العنصر موجود بالفعل.',

    'errors.server': 'حدث خطأ في الخادم. حاول مرة أخرى.',

    'errors.cancelled': 'تم إلغاء العملية.',

    'errors.unknown': 'حدث خطأ غير متوقع. حاول مرة أخرى.',
  };
}
