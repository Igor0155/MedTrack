import 'package:flutter/material.dart';

class SwitchSave extends StatefulWidget {
  final bool isSaveLogin;
  final ValueChanged<bool>? onItemSelected;
  const SwitchSave({super.key, required this.isSaveLogin, required this.onItemSelected});

  @override
  State<SwitchSave> createState() => SwitchSaveState();
}

class SwitchSaveState extends State<SwitchSave> {
  late bool _isActive;
  @override
  void initState() {
    super.initState();
    _isActive = widget.isSaveLogin;
  }

  void setNewValueSwitch(bool value) {
    setState(() {
      _isActive = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 0.80,
      child: Switch(
        value: _isActive,
        onChanged: (value) async {
          setState(() {
            _isActive = value;
          });
          widget.onItemSelected!.call(value);
        },
        materialTapTargetSize: MaterialTapTargetSize.padded,
        activeColor: Theme.of(context).primaryColor,
        inactiveThumbColor: Theme.of(context).colorScheme.outline,
        inactiveTrackColor: Theme.of(context).colorScheme.outline.withOpacity(.48),
        trackOutlineColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return Colors.transparent;
          }
          return Colors.black26;
        }),
        trackOutlineWidth: WidgetStateProperty.resolveWith<double?>((Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return 0.48;
          }
          return 0.48;
        }),
        thumbIcon: WidgetStateProperty.resolveWith<Icon>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return Icon(Icons.check, color: Theme.of(context).colorScheme.onPrimary);
            }
            return Icon(Icons.close, color: Theme.of(context).colorScheme.shadow);
          },
        ),
      ),
    );
  }
}
