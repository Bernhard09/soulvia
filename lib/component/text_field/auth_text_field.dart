import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final bool isEmail;
  final bool isPassword;
  final Widget? suffixIcon;
  final TextEditingController? controller;

  const AuthTextField({
    super.key,
    required this.label,
    this.hintText = '',
    this.isEmail = false,
    this.isPassword = false,
    this.suffixIcon,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label Input (misal: "Username" atau "Password")
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        // Field Input
        TextField(
          controller: controller,
          obscureText: isPassword, // Untuk menyembunyikan teks (password)
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey),
            suffixIcon: suffixIcon, // Icon mata di sebelah kanan
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFF009F9D),
              ), // Warna AppColors.primary
            ),
          ),
        ),
      ],
    );
  }
}
