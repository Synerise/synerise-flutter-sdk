import '../../utils/synerise_utils.dart';

/// The AssignVoucherData class represents data related to a voucher, including its code, expiration
/// date, redemption date, and creation/update timestamps.
class AssignVoucherData {
  String code;
  DateTime? expireIn;
  DateTime? redeemAt;
  DateTime? assignedAt;
  DateTime createdAt;
  DateTime updatedAt;

  AssignVoucherData({
    required this.code,
    this.expireIn,
    this.redeemAt,
    this.assignedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  /// `AssignVoucherData.fromMap(Map map)` is a named constructor that creates an instance of the
  /// `AssignVoucherData` class from a `Map` object. It takes a `Map` object as an argument and uses its
  /// values to initialize the properties of the `AssignVoucherData` object.
  AssignVoucherData.fromMap(Map map)
      : this(
            code: map['code'],
            expireIn: map['expireIn'] != null
                ? SyneriseUtils.formatIntToDateTime(map['expireIn']! * 1000)
                : null,
            redeemAt: map['redeemAt'] != null
                ? SyneriseUtils.formatIntToDateTime(map['redeemAt']! * 1000)
                : null,
            assignedAt: map['assignedAt'] != null
                ? SyneriseUtils.formatIntToDateTime(map['assignedAt']! * 1000)
                : null,
            createdAt:
                SyneriseUtils.formatIntToDateTime(map['createdAt']! * 1000),
            updatedAt:
                SyneriseUtils.formatIntToDateTime(map['updatedAt']! * 1000));

  /// This function returns a map containing various properties of an object, including timestamps.
  Map asMap() => {
        'code': code,
        'expireIn': expireIn?.millisecondsSinceEpoch,
        'redeemAt': redeemAt?.millisecondsSinceEpoch,
        'assignedAt': assignedAt?.millisecondsSinceEpoch,
        'createdAt': createdAt.millisecondsSinceEpoch,
        'updatedAt': updatedAt.millisecondsSinceEpoch,
      };
}
