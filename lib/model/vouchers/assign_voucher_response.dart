import 'assign_voucher_data.dart';

/// The AssignVoucherResponse class represents a response object with a message and optional data, which
/// can be initialized from a map.
class AssignVoucherResponse {
  final String message;
  final AssignVoucherData? data;

  AssignVoucherResponse({
    required this.message,
    this.data,
  });

  /// `AssignVoucherResponse.fromMap(Map map) : this(message: map['message'], data:
  /// AssignVoucherData.fromMap(map['data']));` is a constructor that takes a map as input and
  /// initializes an `AssignVoucherResponse` object with the values extracted from the map. It uses the
  /// `message` key from the map to initialize the `message` field of the `AssignVoucherResponse`
  /// object, and it uses the `data` key from the map to initialize the `data` field of the
  /// `AssignVoucherResponse` object by calling the `AssignVoucherData.fromMap` constructor with the
  /// value associated with the `data` key. The `fromMap` constructor is a common pattern in Dart for
  /// initializing objects from maps, which is often used when parsing JSON data.
  AssignVoucherResponse.fromMap(Map map) : this(message: map['message'], data: AssignVoucherData.fromMap(map['data']));
}
