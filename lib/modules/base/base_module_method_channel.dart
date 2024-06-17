import 'package:flutter/services.dart';
import '../../main/dependencies.dart';
import '../../model/base/mappings.dart';

/// The class `BaseMethodChannel` contains instances of method channels for regular and background
/// communication in Dart.

class BaseMethodChannel {
  final methodChannel = Dependencies.methodChannel;
  final backgroundMethodChannel = Dependencies.backgroundMethodChannel;
}

class SyneriseError {
  int code;
  String message;
  dynamic details;
  String? stacktrace;
  static int defaultUnknownErrorCode = -1;

  SyneriseError(this.code, this.message, {this.details, this.stacktrace});

  static SyneriseError fromObject(dynamic error) {
    if (error is PlatformException) {
      return SyneriseError.fromException(error);
    }
    return SyneriseError.unknownError(error);
  }

  static SyneriseError fromException(PlatformException exception) {
    int code;
    try {
      code = int.parse(exception.code);
    } on FormatException {
      code = defaultUnknownErrorCode;
    }
    String? message = exception.message;

    return SyneriseError(code, message ?? 'No error message provided',
        details: exception.details, stacktrace: exception.stacktrace);
  }

  static SyneriseError unknownError(dynamic error) {
    return SyneriseError(defaultUnknownErrorCode, error.toString());
  }

  static SyneriseError unknownApiCommunicationError() {
    return SyneriseError(defaultUnknownErrorCode,
        "An unknown error has occurred with backend communication.");
  }
}

class SyneriseResult<T> {
  T? result;
  SyneriseError? error;

  SyneriseResult(this.result, this.error);

  SyneriseResult<T> onSuccess(void Function(T result) callback) {
    if (result != null) {
      callback(result as T);
    }

    return this;
  }

  SyneriseResult<T> onError(void Function(SyneriseError error) callback) {
    if (error != null) {
      callback(error!);
    }

    return this;
  }
}

class SyneriseInvocation {
  final MethodChannel methodChannel;

  SyneriseInvocation(this.methodChannel);

  Future<T> invokeSDKMethod<T>(String invokeMethodName,
      {dynamic parameters,
      bool isMappable = false,
      GenericTypeKey? genericTypeKey}) async {
    T? result;
    await methodChannel
        .invokeMethod(invokeMethodName, parameters)
        .then((dynamic value) {
      if (!isMappable) {
        if (value is T) {
          result = value;
        } else {
          result = null;
        }
      } else {
        dynamic finalValue = genericTypeKey != null
            ? Mappings.makeGenericMapping(genericTypeKey, value)
            : Mappings.makeMapping<T>(value as Map);

        if (finalValue != null && finalValue is T) {
          result = finalValue;
        } else {
          result = null;
        }
      }
    }).catchError((e) {
      result = null;
    });

    return Future.value(result);
  }

  Future<SyneriseResult<T>> invokeSDKApiMethod<T>(String invokeMethodName,
      {dynamic parameters,
      bool isMappable = false,
      GenericTypeKey? genericTypeKey}) async {
    SyneriseResult<T>? result;
    await Dependencies.backgroundMethodChannel
        .invokeMethod(invokeMethodName, parameters)
        .then((dynamic value) {
      if (!isMappable) {
        if (value is T) {
          result = SyneriseResult<T>(value, null);
        } else {
          result = SyneriseResult<T>(
              null, SyneriseError.unknownApiCommunicationError());
        }
      } else {
        dynamic finalValue = genericTypeKey != null
            ? Mappings.makeGenericMapping(genericTypeKey, value)
            : Mappings.makeMapping<T>(value as Map);

        if (finalValue != null && finalValue is T) {
          result = SyneriseResult<T>(finalValue, null);
        } else {
          result = SyneriseResult<T>(
              null, SyneriseError.unknownApiCommunicationError());
        }
      }
    }).catchError((e) {
      result = SyneriseResult<T>(null, SyneriseError.fromObject(e));
    });
    return Future.value(result);
  }
}
