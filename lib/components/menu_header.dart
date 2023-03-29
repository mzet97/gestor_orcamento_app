import 'package:flutter/material.dart';

class MenuHeader extends StatelessWidget {
  const MenuHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const DrawerHeader(
      decoration: BoxDecoration(
          color: Colors.blue,
          image: DecorationImage(
              image: AssetImage("assets/images/meu_logo.png"),
              fit: BoxFit.cover)
      ),
      child: Text(""),
    );
  }
}
