import 'package:flutter/material.dart';
import 'package:synerise_flutter_sdk/synerise.dart';

import 'package:synerise_flutter_sdk_example/classes/utils.dart';

class PromotionsMethodsView extends StatefulWidget {
  const PromotionsMethodsView({super.key});

  @override
  State<PromotionsMethodsView> createState() => _PromotionsMethodsViewState();
}

class _PromotionsMethodsViewState extends State<PromotionsMethodsView> with AutomaticKeepAliveClientMixin {
  final uuidController = TextEditingController();
  final getPromotionByUuidForm = GlobalKey<FormState>();

  final codeController = TextEditingController();
  final getPromotionByCodeForm = GlobalKey<FormState>();

  final poolUuidController = TextEditingController();
  final getOrAssignVoucherForm = GlobalKey<FormState>();

  _tempFormBody() {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Padding(padding: EdgeInsets.all(15), child: Text("getAllPromotions Test")),
            ElevatedButton.icon(
                onPressed: () => _getAllPromotionsCall(), icon: const Icon(Icons.all_out_outlined), label: const Text('getAllPromotions')),
            ElevatedButton.icon(
                onPressed: () => _getPromotionsCall(), icon: const Icon(Icons.percent_rounded), label: const Text('getPromotions')),
            const Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            Form(
                key: getPromotionByUuidForm,
                child: Column(
                  children: [
                    const Padding(padding: EdgeInsets.all(15), child: Text("PromotionByUUID Test")),
                    SizedBox(
                        width: 350,
                        child: TextFormField(
                          controller: uuidController,
                          decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "uuid"),
                          keyboardType: TextInputType.text,
                        )),
                    ElevatedButton.icon(
                        onPressed: () => _getPromotionByUuidCall(uuidController.text),
                        icon: const Icon(Icons.percent_outlined),
                        label: const Text('getPromotionByUUID')),
                    ElevatedButton.icon(
                        onPressed: () => _activatePromotionByUUIDCall(uuidController.text),
                        icon: const Icon(Icons.radio_button_checked_outlined),
                        label: const Text('activatePromotionByUUID')),
                    ElevatedButton.icon(
                        onPressed: () => _deactivatePromotionByUUIDCall(uuidController.text),
                        icon: const Icon(Icons.radio_button_unchecked_outlined),
                        label: const Text('deactivatePromotionByUUID')),
                  ],
                )),
            const Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            Form(
                key: getPromotionByCodeForm,
                child: Column(
                  children: [
                    const Padding(padding: EdgeInsets.all(15), child: Text("PromotionByCode Test")),
                    SizedBox(
                        width: 350,
                        child: TextFormField(
                          controller: codeController,
                          decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "code"),
                          keyboardType: TextInputType.text,
                        )),
                    ElevatedButton.icon(
                        onPressed: () => _getPromotionByCodeCall(codeController.text),
                        icon: const Icon(Icons.percent_sharp),
                        label: const Text('getPromotionByCode')),
                    ElevatedButton.icon(
                        onPressed: () => _activatePromotionByCodeCall(codeController.text),
                        icon: const Icon(Icons.radio_button_checked_outlined),
                        label: const Text('activatePromotionByCode')),
                    ElevatedButton.icon(
                        onPressed: () => _deactivatePromotionByCodeCall(codeController.text),
                        icon: const Icon(Icons.radio_button_unchecked_outlined),
                        label: const Text('deactivatePromotionByCode')),
                  ],
                )),
            const Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            ElevatedButton.icon(
                onPressed: () => _activatePromotionsBatchCall(),
                icon: const Icon(Icons.checklist_outlined),
                label: const Text('activatePromotionsBatch')),
            ElevatedButton.icon(
                onPressed: () => _deactivatePromotionsBatchCall(),
                icon: const Icon(Icons.checklist_rtl_outlined),
                label: const Text('deactivatePromotionsBatch')),
            const Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            Form(
                key: getOrAssignVoucherForm,
                child: Column(
                  children: [
                    const Padding(padding: EdgeInsets.all(15), child: Text("getOrAssignVoucher Test")),
                    SizedBox(
                        width: 350,
                        child: TextFormField(
                          controller: poolUuidController,
                          decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "poolUUID"),
                          keyboardType: TextInputType.text,
                        )),
                    ElevatedButton.icon(
                        onPressed: () => _getOrAssignVoucherCall(poolUuidController.text),
                        icon: const Icon(Icons.assignment_add),
                        label: const Text('getOrAssignVoucher')),
                    ElevatedButton.icon(
                        onPressed: () => _assignVoucherCodeCall(poolUuidController.text),
                        icon: const Icon(Icons.assignment_turned_in),
                        label: const Text('assignVoucherCodeCall')),
                    ElevatedButton.icon(
                        onPressed: () => _getAssignedVoucherCodesCall(),
                        icon: const Icon(Icons.assignment_return_sharp),
                        label: const Text('getAssignedVoucherCodesCall')),
                  ],
                )),
            const Divider(
              thickness: 1,
              color: Colors.grey,
            ),
          ],
        ));
  }

  Future<void> _getAllPromotionsCall() async {
    PromotionResponse promotionResponse = await Synerise.promotions.getAllPromotions().catchError((error) {
      String errorMessage = Utils.handleTypeError(error);
      Utils.displaySimpleAlert("error on handling api call \n $errorMessage", context);
      throw Exception(errorMessage);
    });
    if (!mounted) return;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              content: SingleChildScrollView(
                  child: Column(children: [
            const Text(
              'Promotions Map',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            Container(
                width: double.infinity,
                margin: const EdgeInsets.all(5.0),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(border: Border.all(width: 0.5, color: Colors.black)),
                child: Text(promotionResponse.items.toString(), textScaleFactor: 0.5))
          ])));
        });
  }

  Future<void> _getPromotionsCall() async {
    List<PromotionStatus> promotionsStatusList = <PromotionStatus>[PromotionStatus.active];
    List<PromotionType> promotionTypeList = <PromotionType>[PromotionType.general];
    List<ApiQuerySorting> apiQuerySortingList = <ApiQuerySorting>[
      ApiQuerySorting(property: PromotionSortingKey.expireAt, order: ApiQuerySortingOrder.ascending)
    ];
    PromotionsApiQuery promotionsApiQuery = PromotionsApiQuery(
        statuses: promotionsStatusList, types: promotionTypeList, sorting: apiQuerySortingList, limit: 10, page: 10, includeMeta: true);
    PromotionResponse promotionResponse = await Synerise.promotions.getPromotions(promotionsApiQuery).catchError((error) {
      String errorMessage = Utils.handlePlatformException(error);
      Utils.displaySimpleAlert("error on handling api call \n $errorMessage", context);
      throw Exception(errorMessage);
    });
    if (!mounted) return;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              content: SingleChildScrollView(
                  child: Column(children: [
            const Text(
              'Promotions Map',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            Container(
                width: double.infinity,
                margin: const EdgeInsets.all(5.0),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(border: Border.all(width: 0.5, color: Colors.black)),
                child: Text(promotionResponse.items.toString(), textScaleFactor: 0.5))
          ])));
        });
  }

  Future<void> _getPromotionByUuidCall(String uuid) async {
    Promotion promotion = await Synerise.promotions.getPromotionByUUID(uuid).catchError((error) {
      String errorMessage = Utils.handlePlatformException(error);
      Utils.displaySimpleAlert("error on handling api call \n $errorMessage", context);
      throw Exception(errorMessage);
    });
    if (!mounted) return;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              content: SingleChildScrollView(
                  child: Column(children: [
            const Text(
              'Promotion Map',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            Container(
                width: double.infinity,
                margin: const EdgeInsets.all(5.0),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(border: Border.all(width: 0.5, color: Colors.black)),
                child: Text(promotion.name.toString(), textScaleFactor: 0.5))
          ])));
        });
  }

  Future<void> _getPromotionByCodeCall(String code) async {
    Promotion promotion = await Synerise.promotions.getPromotionByCode(code).catchError((error) {
      String errorMessage = Utils.handlePlatformException(error);
      Utils.displaySimpleAlert("error on handling api call \n $errorMessage", context);
      throw Exception(errorMessage);
    });
    if (!mounted) return;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              content: SingleChildScrollView(
                  child: Column(children: [
            const Text(
              'Promotion Map',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            Container(
                width: double.infinity,
                margin: const EdgeInsets.all(5.0),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(border: Border.all(width: 0.5, color: Colors.black)),
                child: Text(promotion.name.toString(), textScaleFactor: 0.5))
          ])));
        });
  }

  Future<void> _activatePromotionByUUIDCall(String uuid) async {
    await Synerise.promotions.activatePromotionByUUID(uuid).catchError((error) {
      String errorMessage = Utils.handlePlatformException(error);
      Utils.displaySimpleAlert("error on handling api call \n $errorMessage", context);
      throw Exception(errorMessage);
    });
    if (!mounted) return;
    Utils.displaySimpleAlert('$uuid activated succesfully', context);
  }

  Future<void> _activatePromotionByCodeCall(String code) async {
    await Synerise.promotions.activatePromotionByCode(code).catchError((error) {
      String errorMessage = Utils.handlePlatformException(error);
      Utils.displaySimpleAlert("error on handling api call \n $errorMessage", context);
      throw Exception(errorMessage);
    });
    if (!mounted) return;
    Utils.displaySimpleAlert('$code activated succesfully', context);
  }

  Future<void> _deactivatePromotionByUUIDCall(String uuid) async {
    await Synerise.promotions.deactivatePromotionByUUID(uuid).catchError((error) {
      String errorMessage = Utils.handlePlatformException(error);
      Utils.displaySimpleAlert("error on handling api call \n $errorMessage", context);
      throw Exception(errorMessage);
    });
    if (!mounted) return;
    Utils.displaySimpleAlert('$uuid activated succesfully', context);
  }

  Future<void> _deactivatePromotionByCodeCall(String code) async {
    await Synerise.promotions.deactivatePromotionByCode(code).catchError((error) {
      String errorMessage = Utils.handlePlatformException(error);
      Utils.displaySimpleAlert("error on handling api call \n $errorMessage", context);
      throw Exception(errorMessage);
    });

    if (!mounted) return;
    Utils.displaySimpleAlert('$code activated succesfully', context);
  }

  Future<void> _activatePromotionsBatchCall() async {
    PromotionIdentifier promotionIdentifier = PromotionIdentifier(key: PromotionIdentifierKey.uuid, value: 'value');
    PromotionIdentifier promotionIdentifier2 = PromotionIdentifier(key: PromotionIdentifierKey.code, value: 'value');
    List<PromotionIdentifier> promotionIdentifierList = <PromotionIdentifier>[promotionIdentifier, promotionIdentifier2];
    await Synerise.promotions.activatePromotionsBatch(promotionIdentifierList).catchError((error) {
      String errorMessage = Utils.handlePlatformException(error);
      Utils.displaySimpleAlert("error on handling api call \n $errorMessage", context);
      throw Exception(errorMessage);
    });
    if (!mounted) return;
    Utils.displaySimpleAlert('promotion batch activated succesfully', context);
  }

  Future<void> _deactivatePromotionsBatchCall() async {
    PromotionIdentifier promotionIdentifier = PromotionIdentifier(key: PromotionIdentifierKey.uuid, value: 'value');
    PromotionIdentifier promotionIdentifier2 = PromotionIdentifier(key: PromotionIdentifierKey.code, value: 'value');
    List<PromotionIdentifier> promotionIdentifierList = <PromotionIdentifier>[promotionIdentifier, promotionIdentifier2];
    await Synerise.promotions.deactivatePromotionsBatch(promotionIdentifierList).catchError((error) {
      String errorMessage = Utils.handlePlatformException(error);
      Utils.displaySimpleAlert("error on handling api call \n $errorMessage", context);
      throw Exception(errorMessage);
    });
    if (!mounted) return;
    Utils.displaySimpleAlert('promotion batch deactivated succesfully', context);
  }

  Future<void> _getOrAssignVoucherCall(String poolUuid) async {
    AssignVoucherResponse assignVoucherResponse = await Synerise.promotions.getOrAssignVoucher(poolUuid).catchError((error) {
      String errorMessage = Utils.handlePlatformException(error);
      Utils.displaySimpleAlert("error on handling api call \n $errorMessage", context);
      throw Exception(errorMessage);
    });
    if (!mounted) return;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              content: SingleChildScrollView(
                  child: Column(children: [
            const Text(
              'AssignVoucherResponse Map',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            Container(
                width: double.infinity,
                margin: const EdgeInsets.all(5.0),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(border: Border.all(width: 0.5, color: Colors.black)),
                child: Text(assignVoucherResponse.message, textScaleFactor: 0.5))
          ])));
        });
  }

  Future<void> _assignVoucherCodeCall(String poolUuid) async {
    AssignVoucherResponse assignVoucherResponse = await Synerise.promotions.assignVoucherCode(poolUuid).catchError((error) {
      String errorMessage = Utils.handlePlatformException(error);
      Utils.displaySimpleAlert("error on handling api call \n $errorMessage", context);
      throw Exception(errorMessage);
    });
    if (!mounted) return;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              content: SingleChildScrollView(
                  child: Column(children: [
            const Text(
              'AssignVoucherResponse Map',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            Container(
                width: double.infinity,
                margin: const EdgeInsets.all(5.0),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(border: Border.all(width: 0.5, color: Colors.black)),
                child: Text(assignVoucherResponse.message, textScaleFactor: 0.5))
          ])));
        });
  }

  Future<void> _getAssignedVoucherCodesCall() async {
    VoucherCodesResponse voucherCodesResponse = await Synerise.promotions.getAssignedVoucherCodes().catchError((error) {
      String errorMessage = Utils.handlePlatformException(error);
      Utils.displaySimpleAlert("error on handling api call \n $errorMessage", context);
      throw Exception(errorMessage);
    });
    if (!mounted) return;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              content: SingleChildScrollView(
                  child: Column(children: [
            const Text(
              'VoucherCodesResponse Map',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            Container(
                width: double.infinity,
                margin: const EdgeInsets.all(5.0),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(border: Border.all(width: 0.5, color: Colors.black)),
                child: Text(voucherCodesResponse.data.toString(), textScaleFactor: 0.5))
          ])));
        });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return (Container(child: _tempFormBody()));
  }

  @override
  bool get wantKeepAlive => true;
}
