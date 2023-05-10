import '../../utils/synerise_utils.dart';

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

  AssignVoucherData.fromMap(Map map)
      : this(
            code: map['code'],
            expireIn: map['expireIn'] != null ? SyneriseUtils.formatIntToDateTime(map['expireIn']! * 1000) : null,
            redeemAt: map['redeemAt'] != null ? SyneriseUtils.formatIntToDateTime(map['redeemAt']! * 1000) : null,
            assignedAt: map['assignedAt'] != null ? SyneriseUtils.formatIntToDateTime(map['assignedAt']! * 1000) : null,
            createdAt: SyneriseUtils.formatIntToDateTime(map['createdAt']! * 1000),
            updatedAt: SyneriseUtils.formatIntToDateTime(map['updatedAt']! * 1000));

  Map asMap() => {
        'code': code,
        'expireIn': expireIn?.millisecondsSinceEpoch,
        'redeemAt': redeemAt?.millisecondsSinceEpoch,
        'assignedAt': assignedAt?.millisecondsSinceEpoch,
        'createdAt': createdAt.millisecondsSinceEpoch,
        'updatedAt': updatedAt.millisecondsSinceEpoch,
      };
}
