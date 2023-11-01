import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextInputType keyboard;
  final String label;
  final bool? showVisibilityIcon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final void Function(String)? onChanged;
  final AutovalidateMode? autovalidateMode;

  const CustomTextField({
    Key? key,
    required this.keyboard,
    required this.label,
    this.showVisibilityIcon,
    this.controller,
    this.autovalidateMode,
    this.validator,
    this.onSaved,
    this.onChanged,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool hideText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      onSaved: widget.onSaved,
      onChanged: widget.onChanged,
      autovalidateMode: widget.autovalidateMode,
      keyboardType: widget.keyboard,
      cursorColor: Colors.black,
      obscureText: widget.showVisibilityIcon == true ? hideText : false,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 19),
        filled: true,
        fillColor: const Color(0xFFF4F4F4),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(4),
        ),
        hintText: widget.label,
        hintStyle: const TextStyle(
          fontSize: 14,
          color: Color(0xFF1D1D1D),
          fontWeight: FontWeight.w400,
        ),
        suffixIcon: widget.showVisibilityIcon == true
            ? IconButton(
                onPressed: () {
                  setState(() {
                    hideText = !hideText;
                  });
                },
                splashColor: Colors.transparent,
                icon: hideText
                    ? const Icon(
                        IconsaxOutline.unlock,
                        color: Colors.black,
                        size: 18,
                      )
                    : const Icon(
                        IconsaxOutline.lock_slash,
                        color: Colors.black,
                        size: 18,
                      ),
              )
            : null,
      ),
    );
  }
}
