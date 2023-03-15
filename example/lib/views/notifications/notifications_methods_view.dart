import 'package:flutter/material.dart';

class NotificationsMethodsView extends StatefulWidget {
  const NotificationsMethodsView({super.key});

  @override
  State<NotificationsMethodsView> createState() => _NotificationsMethodsViewState();
}

class _NotificationsMethodsViewState extends State<NotificationsMethodsView> with AutomaticKeepAliveClientMixin {
  _tempFormBody() {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          const Padding(padding: EdgeInsets.all(15), child: Text("Native registerForNotifications test + firebase initialize")),
          ElevatedButton(child: const Text('Notifications test'), onPressed: () => _registerForPushCall()),
        ]));
  }

  Future<void> _registerForPushCall() async {
    //TODO: notifications test
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
