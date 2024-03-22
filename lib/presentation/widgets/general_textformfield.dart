import 'package:flutter/material.dart';
import 'package:instaclone/presentation/resources/colors_manager.dart';

class GeneralTextFormField extends StatefulWidget {
  final bool hasSuffixIcon;
  final bool hasPrefixIcon;
  final TextEditingController controller;
  final String label;
  final String? Function(String?) validator;
  final TextInputType textInputType;
  final IconData iconData;
  final bool autoFocus;
  const GeneralTextFormField({
    Key? key,
    required this.hasPrefixIcon,
    required this.hasSuffixIcon,
    required this.controller,
    required this.label,
    required this.validator,
    required this.textInputType,
    required this.iconData,
    required this.autoFocus,
  }) : super(key: key);

  @override
  State<GeneralTextFormField> createState() => _GeneralTextFormFieldState();
}

class _GeneralTextFormFieldState extends State<GeneralTextFormField> {
  bool isVisible = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(
        color: Colors.white,
      ),
      cursorColor: Colors.white,
      autofocus: widget.autoFocus,
      obscureText: widget.hasSuffixIcon ? isVisible : false,
      keyboardType: widget.textInputType,
      validator: widget.validator,
      controller: widget.controller,
      decoration: InputDecoration(
        label: Text(
          widget.label,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        prefixIcon: widget.hasPrefixIcon
            ? Icon(
                widget.iconData,
                color: Colors.white,
              )
            : null,
        suffixIcon: widget.hasSuffixIcon
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isVisible = !isVisible;
                  });
                },
                icon: isVisible
                    ? const Icon(
                        Icons.visibility,
                        color: Colors.white,
                      )
                    : const Icon(
                        Icons.visibility_off,
                        color: Colors.white,
                      ),
              )
            : null,
      ),
      onSaved: (text) {
        widget.controller.text = text!;
      },
    );
  }
}
