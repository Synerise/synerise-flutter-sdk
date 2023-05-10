import 'voucher_codes_data.dart';

class VoucherCodesResponse {
  final List<VoucherCodesData> data;

  VoucherCodesResponse({required this.data});

  VoucherCodesResponse.fromMap(Map map)
      : this(
          data: _convertDataListToVoucherCodesData(map['data']),
        );
}

List<VoucherCodesData> _convertDataListToVoucherCodesData(List<Object?> list) {
  List<VoucherCodesData> voucherCodesDataList = [];
  for (var voucherCodesDataMap in list) {
    voucherCodesDataMap as Map<Object?, Object?>;
    VoucherCodesData voucherCodesData = VoucherCodesData.fromMap(voucherCodesDataMap);
    voucherCodesDataList.add(voucherCodesData);
  }
  return voucherCodesDataList;
}
