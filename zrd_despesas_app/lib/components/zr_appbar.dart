import 'package:flutter/material.dart';

class ZrAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  final List<Widget>? actions;

  const ZrAppbar({super.key, required this.title, this.actions});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: actions,
      centerTitle: true,
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'JetBrainsMono',
          fontWeight: FontWeight.w100,
          fontSize: 17,
          color: Colors.white,
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 75, 85, 99),
    );
  }
}
