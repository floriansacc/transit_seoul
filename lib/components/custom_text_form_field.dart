import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.focusNode,
    required this.controller,
    this.hintText,
    this.errorText,
    required this.textInputAction,
    this.masks,
    this.validator,
    this.onChange,
    this.onSaved,
    this.keyboardType = TextInputType.text,
  });

  final FocusNode focusNode;
  final TextEditingController controller;
  final String? hintText;
  final String? errorText;
  final TextInputAction textInputAction;
  final List<TextInputFormatter>? masks;
  final String? Function(String?)? validator;
  final void Function(String?)? onChange;
  final void Function(String?)? onSaved;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      controller: controller,
      inputFormatters: masks ?? [],
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      onChanged: onChange,
      onSaved: onSaved,
      validator: validator,
      decoration: InputDecoration(
        errorText: errorText,
        hintText: hintText,
        counterText: '',
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Theme.of(context).colorScheme.primary,
          ),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Theme.of(context).colorScheme.error,
          ),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Theme.of(context).colorScheme.error,
          ),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Theme.of(context).disabledColor,
          ),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    );
  }
}
