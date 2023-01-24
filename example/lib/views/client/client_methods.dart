import 'package:flutter/material.dart';
import 'package:synerise_flutter_sdk_example/views/client/register.dart';
import 'package:synerise_flutter_sdk_example/views/client/signin.dart';

class ClientMethods extends StatefulWidget {
  const ClientMethods({super.key});

  @override
  State<ClientMethods> createState() => _ClientMethodsState();
}

class _ClientMethodsState extends State<ClientMethods> with AutomaticKeepAliveClientMixin {
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
            label: const Text('Sign in')),
        ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegisterAccountView()),
              );
            },
            icon: const Icon(Icons.logout),
            label: const Text('Register')),
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
        title: const Text('SignIn Native Method Test'),
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
