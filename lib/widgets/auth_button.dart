import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final void Function()? onPressed;
  final String label;
  final bool isSubmitting;
  const AuthButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.isSubmitting = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isSubmitting ? null : onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shadowColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        minimumSize: const Size(double.infinity, 60),
        disabledBackgroundColor: const Color(0xFF00B2FF).withOpacity(0.5),
        backgroundColor: const Color(0xFF00B2FF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      child: isSubmitting
          ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
    );
  }
}
