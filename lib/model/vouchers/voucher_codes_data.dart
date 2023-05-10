import '../../enums/vouchers/voucher_code_status.dart';
import '../../utils/synerise_utils.dart';

class VoucherCodesData {
  String code;
  VoucherCodeStatus status;
  int clientId;
  String? clientUuid;
  String poolUuid;
  DateTime? expireIn;
  DateTime? redeemAt;
  DateTime? assignedAt;
  DateTime createdAt;
  DateTime updatedAt;

  VoucherCodesData({
    required this.code,
    required this.status,
    required this.clientId,
    this.clientUuid,
    required this.poolUuid,
    this.expireIn,
    this.redeemAt,
    this.assignedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  VoucherCodesData.fromMap(Map map)
      : this(
          code: map['code'],
          status: VoucherCodeStatus.getVoucherCodeStatusFromString(map['status']),
          clientId: map['clientId'],
          clientUuid: map['clientUuid'],
          poolUuid: map['poolUuid'],
          expireIn: map['expireIn'] != null ? SyneriseUtils.formatIntToDateTime(map['expireIn'] * 1000) : null,
          redeemAt: map['redeemAt'] != null ? SyneriseUtils.formatIntToDateTime(map['redeemAt'] * 1000) : null,
          assignedAt: map['assignedAt'] != null ? SyneriseUtils.formatIntToDateTime(map['assignedAt'] * 1000) : null,
          createdAt: SyneriseUtils.formatIntToDateTime(map['createdAt'] * 1000),
          updatedAt: SyneriseUtils.formatIntToDateTime(map['updatedAt'] * 1000),
        );
}
