import 'dart:async';
import 'package:flutter/material.dart';
import 'package:synerise_flutter_sdk/synerise.dart';

import '../../classes/utils.dart';

class UpdateAccount extends StatefulWidget {
  const UpdateAccount({super.key});

  @override
  State<UpdateAccount> createState() => _UpdateAccountState();
}

class _UpdateAccountState extends State<UpdateAccount>
    with AutomaticKeepAliveClientMixin {
  final emailController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final sexController = TextEditingController();
  final phoneController = TextEditingController();
  final companyController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final zipCodeController = TextEditingController();
  final countryCodeController = TextEditingController();
  final provinceController = TextEditingController();

  final updateForm = GlobalKey<FormState>();

  _tempFormBody() {
    return Form(
        //autovalidate: true,
        key: updateForm,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.text,
              ),
              TextFormField(
                controller: firstNameController,
                decoration: const InputDecoration(labelText: "First Name"),
              ),
              TextFormField(
                controller: lastNameController,
                decoration: const InputDecoration(labelText: "Last Name"),
              ),
              TextFormField(
                controller: sexController,
                decoration: const InputDecoration(labelText: "Sex"),
              ),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: "Phone"),
              ),
              TextFormField(
                controller: companyController,
                decoration: const InputDecoration(labelText: "Company name"),
              ),
              TextFormField(
                controller: addressController,
                decoration: const InputDecoration(labelText: "Address"),
              ),
              TextFormField(
                controller: cityController,
                decoration: const InputDecoration(labelText: "City"),
              ),
              TextFormField(
                controller: zipCodeController,
                decoration: const InputDecoration(labelText: "Zip code"),
              ),
              TextFormField(
                controller: countryCodeController,
                decoration: const InputDecoration(labelText: "Country code"),
              ),
              TextFormField(
                controller: provinceController,
                decoration: const InputDecoration(labelText: "Province"),
              ),
              const SizedBox(height: 10.0),
              ButtonBar(
                children: <Widget>[
                  ElevatedButton.icon(
                      onPressed: () => _updateAccountCall(
                          emailController.text.isEmpty ? null : emailController.text,
                          firstNameController.text.isEmpty ? null : firstNameController.text,
                          lastNameController.text.isEmpty ? null : lastNameController.text,
                          sexController.text.isEmpty ? null : sexController.text,
                          phoneController.text.isEmpty ? null : phoneController.text,
                          companyController.text.isEmpty ? null : companyController.text,
                          addressController.text.isEmpty ? null : addressController.text,
                          cityController.text.isEmpty ? null : cityController.text,
                          zipCodeController.text.isEmpty ? null : zipCodeController.text,
                          countryCodeController.text.isEmpty ? null : countryCodeController.text,
                          provinceController.text.isEmpty ? null : provinceController.text),
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Update Account')),
                ],
              ),
            ],
          ),
        ));
  }

  Future<void> _updateAccountCall(String? email, String? firstName, String? lastName, String? sex,
      String? phone, String? company, String? address, String? city, String? zipcode, String? countrycode, String? province) async {
    ClientAccountUpdateContext clientAccountUpdateContext =
        ClientAccountUpdateContext(
            email: email,
            lastName: lastName,
            firstName: firstName,
            sex: ClientSex.getClientSexFromString(sex ?? "NOT_SPECIFIED"));

    await Synerise.client.updateAccount(clientAccountUpdateContext,
        onSuccess: () {
      Utils.displaySimpleAlert("Account succesfully updated", context);
    }, onError: (SyneriseError error) {
      Utils.displaySimpleAlert(error.message, context);
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    sexController.dispose();
    phoneController.dispose();
    companyController.dispose();
    addressController.dispose();
    cityController.dispose();
    zipCodeController.dispose();
    countryCodeController.dispose();
    provinceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return (Center(child: _tempFormBody()));
  }

  @override
  bool get wantKeepAlive => true;
}
