import 'package:flutter/material.dart';

import 'package:oasx/views/nav/view_nav.dart';

class DesktopLayoutView extends StatelessWidget {
  const DesktopLayoutView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 30,
        toolbarHeight: 50,
        title: const Text("OASX"),
      ),
      body: body(),
    );
  }

  Widget body() {
    return const Row(
      children: <Widget>[
        Nav(),
        VerticalDivider(thickness: 1, width: 1),
        // This is the main content.
        //Expanded 占满剩下屏幕空间
        Expanded(
          child: Center(
            child: Text('selectedIndex'),
          ),
        )
      ],
    );
  }
}
