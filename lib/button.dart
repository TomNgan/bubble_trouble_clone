import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({Key? key, required this.icon, required this.tapHandler})
      : super(key: key);

  final IconData icon;
  final VoidCallback tapHandler;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tapHandler,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          color: Colors.grey[100],
          width: 50,
          height: 50,
          child: Center(child: Icon(icon)),
        ),
      ),
    );
  }
}
