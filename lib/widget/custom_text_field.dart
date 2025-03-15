import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? textEditingController;
  final IconData? iconData;
  final String? hintText;
  final bool isobsecre;
  final bool enabled;
  final TextInputType keyboardType; // ✅ Added keyboardType as a final field

  const CustomTextField({
    super.key,
    this.textEditingController,
    this.iconData,
    this.hintText,
    this.isobsecre = true,
    this.enabled = true,
    this.keyboardType = TextInputType.text, // ✅ Default value
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(8.0),
      child: TextFormField(
        enabled: widget.enabled,
        controller: widget.textEditingController,
        obscureText: widget.isobsecre,
        cursorColor: Theme.of(context).primaryColor,
        keyboardType: widget.keyboardType, // ✅ Now keyboardType is properly used
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            widget.iconData,
            color: Colors.purpleAccent,
          ),
          focusColor: Theme.of(context).primaryColor,
          hintText: widget.hintText,
        ),
      ),
    );
  }
}
