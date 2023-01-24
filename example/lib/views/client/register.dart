import 'package:flutter/material.dart';
import 'package:synerise_flutter_sdk/model/client/register_account.dart';
import 'package:synerise_flutter_sdk/synerise.dart';

class RegisterAccount extends StatefulWidget {
  const RegisterAccount({super.key});

  @override
  State<RegisterAccount> createState() => _RegisterAccountState();
}

class _RegisterAccountState extends State<RegisterAccount> with AutomaticKeepAliveClientMixin {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
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
  final uuidController = TextEditingController();
  final customIdController = TextEditingController();

  final registerForm = GlobalKey<FormState>();

  _tempFormBody() {
    return Form(
        //autovalidate: true,
        key: registerForm,
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
                controller: passwordController,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
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
              TextFormField(
                controller: uuidController,
                decoration: const InputDecoration(labelText: "UUID"),
              ),
              TextFormField(
                controller: customIdController,
                decoration: const InputDecoration(labelText: "Custom ID"),
              ),
              const SizedBox(height: 10.0),
              ButtonBar(
                children: <Widget>[
                  ElevatedButton.icon(
                      onPressed: () => _registerAccountCall(
                          emailController.text,
                          passwordController.text,
                          firstNameController.text,
                          lastNameController.text,
                          sexController.text,
                          phoneController.text,
                          companyController.text,
                          addressController.text,
                          cityController.text,
                          zipCodeController.text,
                          countryCodeController.text,
                          provinceController.text,
                          uuidController.text,
                          customIdController.text),
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Sign in')),
                ],
              ),
            ],
          ),
        ));
  }

  Future<void> _registerAccountCall(
      email, password, firstName, lastName, sex, phone, company, address, city, zipcode, countrycode, province, uuid, customId) async {
    ClientAccountRegisterContext clientAccountRegisterContext = ClientAccountRegisterContext(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        sex: sex,
        phone: phone,
        company: company,
        address: address,
        city: city,
        zipcode: zipcode,
        countrycode: countrycode,
        province: province,
        uuid: uuid,
        customId: customId);

    await Synerise.client.registerAccount(clientAccountRegisterContext).catchError((error) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text("register call failed: $error"),
          );
        },
      );
      throw Exception('Failed to call native register method: $error');
    });
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text("$email account created succesfully"),
        );
      },
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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
    uuidController.dispose();
    customIdController.dispose();
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
