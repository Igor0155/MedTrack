import 'package:flutter/material.dart';

DropdownButtonFormField medDropdownButtonFormField({
  Key? key,
  required String label,
  required List<DropdownMenuItem<String>>? items,
  required void Function(String?)? onChanged,
  List<Widget> Function(BuildContext)? selectedItemBuilder,
  String? value,
  void Function(String?)? onSaved,
  String? Function(String?)? validator,
  bool enabled = true,
}) {
  return DropdownButtonFormField<String>(
    key: key,
    value: value,
    menuMaxHeight: 200,
    decoration: InputDecoration(
      enabled: enabled,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      label: Text(label, overflow: TextOverflow.ellipsis),
    ),
    icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 24),
    items: items,
    selectedItemBuilder: selectedItemBuilder,
    enableFeedback: true,
    onChanged: enabled ? onChanged : null,
    onSaved: onSaved,
    validator: validator,
    isExpanded: true,
  );
}
