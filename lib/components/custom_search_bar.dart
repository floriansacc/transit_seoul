import 'package:flutter/material.dart';
import 'package:transit_seoul/components/confirm_button.dart';
import 'package:transit_seoul/components/custom_text_form_field.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({
    super.key,
    required this.textFormField,
    required this.onTapSearch,
    this.searchDescription,
    this.buttonBgColor,
  });

  final CustomTextFormField textFormField;
  final void Function() onTapSearch;
  final String? searchDescription;
  final Color? buttonBgColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        Flexible(
          flex: 3,
          child: textFormField,
        ),
        Flexible(
          child: ConfirmButton(
            color: buttonBgColor,
            height: 55,
            description: searchDescription ?? '검색',
            onTap: onTapSearch,
          ),
        ),
      ],
    );
  }
}
