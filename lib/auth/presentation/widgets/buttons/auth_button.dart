import 'package:flutter/material.dart';

class AuthButton extends StatefulWidget {
  void Function()? onPressed;
  String text;
  String assetImage;
  AuthButton({
    super.key,
    this.onPressed,
    required this.text,
    required this.assetImage,
  });

  @override
  State<AuthButton> createState() => _AuthButtonState();
}

class _AuthButtonState extends State<AuthButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(15),
        ),
        fixedSize: Size(
          MediaQuery.sizeOf(context).width * 0.6,
          MediaQuery.sizeOf(context).height * 0.05,
        ),
      ),
      onPressed: widget.onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(widget.assetImage, height: 20),
          SizedBox(width: 15),
          Text(widget.text, style: TextStyle(color: Colors.grey, fontSize: 15)),
        ],
      ),
    );
  }
}
