import 'package:boost_fundr/export.dart';

class CustomInput extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final bool obscureText;
  final Function(String)? onChanged;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? errorText;

  const CustomInput({
    super.key, 
    required this.hint,
    this.controller,
    this.obscureText = false,
    this.onChanged,
    this.suffixIcon,
    this.prefixIcon,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        errorText: errorText,
      ),
    );
  }
}
