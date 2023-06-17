import 'voucher_codes_data.dart';

/// The above code defines a Dart class and a private function to convert a list of data objects to a
/// list of voucher codes data objects.
///
/// Args:
///   list (List<Object?>): The list parameter is a List of Object type, which is being passed as an
/// argument to the _convertDataListToVoucherCodesData function. This list is expected to contain maps
/// that represent voucher codes data. The function iterates over each map in the list, converts it to a
/// Voucher
///
/// Returns:
///   The code is defining a class `VoucherCodesResponse` with a constructor that takes a required list
/// of `VoucherCodesData` objects. It also defines a named constructor `fromMap` that takes a `Map`
/// object and returns a `VoucherCodesResponse` object with the `data` field populated by calling
/// `_convertDataListToVoucherCodesData` function on the `data
class VoucherCodesResponse {
  final List<VoucherCodesData> data;

  VoucherCodesResponse({required this.data});

  /// `VoucherCodesResponse.fromMap(Map map)` is a named constructor that takes a `Map` object as an
  /// argument. It then creates a new instance of the `VoucherCodesResponse` class by calling the
  /// default constructor `this(data: ...)`, passing in a list of `VoucherCodesData` objects. The list
  /// is obtained by calling the private `_convertDataListToVoucherCodesData` function on the `data`
  /// field of the input `Map` object. This named constructor is used to create a `VoucherCodesResponse`
  /// object from a `Map` object, which is a common format for data exchange in many programming
  /// languages.
  VoucherCodesResponse.fromMap(Map map)
      : this(
          data: _convertDataListToVoucherCodesData(map['data']),
        );
}

/// This function converts a list of objects to a list of VoucherCodesData objects.
///
/// Args:
///   list (List<Object?>): The parameter `list` is a list of objects that needs to be converted to a
/// list of `VoucherCodesData` objects.
///
/// Returns:
///   a list of `VoucherCodesData` objects.
List<VoucherCodesData> _convertDataListToVoucherCodesData(List<Object?> list) {
  List<VoucherCodesData> voucherCodesDataList = [];
  for (var voucherCodesDataMap in list) {
    voucherCodesDataMap as Map<Object?, Object?>;
    VoucherCodesData voucherCodesData = VoucherCodesData.fromMap(voucherCodesDataMap);
    voucherCodesDataList.add(voucherCodesData);
  }
  return voucherCodesDataList;
}
