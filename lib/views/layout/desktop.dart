import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

import 'package:oasx/views/nav/view_nav.dart';
import 'package:oasx/views/nav_menu/nav_menu_view.dart';

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
    return Row(
      children: <Widget>[
        const Nav(),
        const VerticalDivider(thickness: 1, width: 1),
        Container(
          alignment: Alignment.topLeft,
          width: 180,
          decoration: const BoxDecoration(shape: BoxShape.rectangle),
          child: const NavMenuView(),
        ),
        const VerticalDivider(thickness: 1, width: 1),
        //Expanded 占满剩下屏幕空间

        const Expanded(
          child: Center(
            child: Text('ddd'),
          ),
        )
      ],
    );
  }
}
