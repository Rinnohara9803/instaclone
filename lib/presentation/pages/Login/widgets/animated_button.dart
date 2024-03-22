import 'package:flutter/material.dart';

import '../../../resources/colors_manager.dart';

class AnimatedButton extends StatefulWidget {
  final VoidCallback onTap;
  final String label;
  const AnimatedButton({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  bool _isButtonLongPressed = false;

  void switchIsButtonLongPressed() {
    setState(() {
      _isButtonLongPressed = !_isButtonLongPressed;
    });
  }

  bool _isSignUpButtonLongPressed = false;

  void switchIsSignUpButtonLongPressed() {
    setState(() {
      _isSignUpButtonLongPressed = !_isSignUpButtonLongPressed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      onLongPress: () {
        switchIsButtonLongPressed();
      },
      onLongPressEnd: (_) {
        switchIsButtonLongPressed();
      },
      child: AnimatedContainer(
        margin: EdgeInsets.symmetric(horizontal: _isButtonLongPressed ? 10 : 0),
        height: 51,
        width: double.infinity,
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 39, 71, 229)
              .withOpacity(_isButtonLongPressed ? 0.5 : 1),
          borderRadius: BorderRadius.circular(
            50,
          ),
        ),
        child: Center(
          child: Text(
            widget.label,
            style: TextStyle(
              color: ColorsManager.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
