import 'package:flutter/material.dart';

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      onPressed: () => {Navigator.pop(context)},
      icon: Icon(Icons.arrow_back_ios, color: Colors.white),
    );
  }
}
