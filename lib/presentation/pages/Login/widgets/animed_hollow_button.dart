import 'package:flutter/material.dart';

class AnimatedHollowButton extends StatefulWidget {
  final VoidCallback onTap;
  final String label;
  const AnimatedHollowButton({
    super.key,
    required this.onTap,
    required this.label,
  });

  @override
  State<AnimatedHollowButton> createState() => _AnimatedHollowButtonState();
}

class _AnimatedHollowButtonState extends State<AnimatedHollowButton> {
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
        switchIsSignUpButtonLongPressed();
      },
      onLongPressEnd: (_) {
        switchIsSignUpButtonLongPressed();
      },
      child: AnimatedContainer(
        margin: EdgeInsets.symmetric(
            horizontal: _isSignUpButtonLongPressed ? 10 : 0),
        height: 51,
        width: double.infinity,
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: Colors.white60,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(
            50,
          ),
        ),
        child: Center(
          child: Text(
            widget.label,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
