import 'assign_voucher_data.dart';

class AssignVoucherResponse {
  final String message;
  final AssignVoucherData? data;

  AssignVoucherResponse({
    required this.message,
    this.data,
  });

  AssignVoucherResponse.fromMap(Map map) : this(message: map['message'], data: AssignVoucherData.fromMap(map['data']));
}
