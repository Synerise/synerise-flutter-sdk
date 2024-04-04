import 'package:flutter/material.dart';

import 'simple_authentication_view.dart';
import 'change_email_and_phone_view.dart';
import 'change_password_view.dart';
import 'regenerate_uuid_with_client_id_view.dart';
import 'register_account_view.dart';
import 'signin_view.dart';
import 'update_account_view.dart';
import 'activate_account_by_pin_view.dart';

class ClientMethodsView extends StatefulWidget {
  const ClientMethodsView({super.key});

  @override
  State<ClientMethodsView> createState() => _ClientMethodsViewState();
}

class _ClientMethodsViewState extends State<ClientMethodsView>
    with AutomaticKeepAliveClientMixin {
  _tempFormBody() {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SignInView()),
              );
            },
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Sign in + client methods')),
        ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const RegisterAccountView()),
              );
            },
            icon: const Icon(Icons.logout),
            label: const Text('Register Account')),
        ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const UpdateAccountView()),
              );
            },
            icon: const Icon(Icons.update_outlined),
            label: const Text('Update Account')),
        ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ChangePasswordView()),
              );
            },
            icon: const Icon(Icons.password_sharp),
            label: const Text('Change password')),
        ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ActivateAccountByPinView()),
              );
            },
            icon: const Icon(Icons.pin),
            label: const Text('ActivateAccountByPin')),
        ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ChangeEmailAndPhoneView()),
              );
            },
            icon: const Icon(Icons.email),
            label: const Text('Change phone + change email')),
        ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const RegenerateUUIDWithClientIdentifierView()),
              );
            },
            icon: const Icon(Icons.numbers_outlined),
            label: const Text('RegenerateUUIDWithClientIdentifier')),
        ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SimpleAuthenticationView()),
              );
            },
            icon: const Icon(Icons.person_pin),
            label: const Text('Simple Authentication')),
      ],
    );
  }

  @override
  void dispose() {
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

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SignIn + client methods Native Method Test'),
      ),
      body: const Center(
        child: SignIn(),
      ),
    );
  }
}

class RegisterAccountView extends StatelessWidget {
  const RegisterAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RegisterAccount Native Method Test'),
      ),
      body: const Center(
        child: RegisterAccount(),
      ),
    );
  }
}

class UpdateAccountView extends StatelessWidget {
  const UpdateAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UpdateAccount Native Method Test'),
      ),
      body: const Center(
        child: UpdateAccount(),
      ),
    );
  }
}

class ChangePasswordView extends StatelessWidget {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChangePasswordView Native Method Test'),
      ),
      body: const Center(
        child: ChangePassword(),
      ),
    );
  }
}

class ActivateAccountByPinView extends StatelessWidget {
  const ActivateAccountByPinView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ActivateAccountByPin Native Method Test'),
      ),
      body: const Center(
        child: ActivateAccountByPin(),
      ),
    );
  }
}

class ChangeEmailAndPhoneView extends StatelessWidget {
  const ChangeEmailAndPhoneView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChangeEmailAndPhoneView Native Method Test'),
      ),
      body: const Center(
        child: ChangeEmailAndPhone(),
      ),
    );
  }
}

class RegenerateUUIDWithClientIdentifierView extends StatelessWidget {
  const RegenerateUUIDWithClientIdentifierView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('RegenerateUUIDWithClientIdentifier Native Method Test'),
      ),
      body: const Center(
        child: RegenerateUUIDWithClientIdentifier(),
      ),
    );
  }
}

class SimpleAuthenticationView extends StatelessWidget {
  const SimpleAuthenticationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SimpleAuthentication Native Method Test'),
      ),
      body: const Center(
        child: SimpleAuthentication(),
      ),
    );
  }
}
