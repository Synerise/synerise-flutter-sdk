import 'package:flutter/material.dart';
import 'package:synerise_flutter_sdk_example/views/client/register_account.dart';
import 'package:synerise_flutter_sdk_example/views/client/signin.dart';
import 'package:synerise_flutter_sdk_example/views/client/update_account.dart';

class ClientMethodsView extends StatefulWidget {
  const ClientMethodsView({super.key});

  @override
  State<ClientMethodsView> createState() => _ClientMethodsViewState();
}

class _ClientMethodsViewState extends State<ClientMethodsView> with AutomaticKeepAliveClientMixin {
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
                MaterialPageRoute(builder: (context) => const RegisterAccountView()),
              );
            },
            icon: const Icon(Icons.logout),
            label: const Text('Register Account')),
        ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UpdateAccountView()),
              );
            },
            icon: const Icon(Icons.update_outlined),
            label: const Text('Update Account')),
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
