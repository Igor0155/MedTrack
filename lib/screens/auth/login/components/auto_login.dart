import 'package:flutter/material.dart';
import 'package:meditrack/main.dart';
import 'package:meditrack/screens/auth/login/type.dart';
import 'package:meditrack/shared/components/d3_elevated_button.dart';

class AutoLogin extends StatefulWidget {
  final void Function() onPressedButtonAccess;
  final void Function() onPressedButtonChange;
  final Widget? childButtonAccess;
  final InputLoginDto inputLoginDto;

  const AutoLogin({
    super.key,
    required this.onPressedButtonAccess,
    required this.childButtonAccess,
    required this.inputLoginDto,
    required this.onPressedButtonChange,
  });

  @override
  State<AutoLogin> createState() => _AutoLoginState();
}

class _AutoLoginState extends State<AutoLogin> {
  final isTablet = getIt.get<bool>(instanceName: 'isTabletDevice');
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: Theme.of(context).colorScheme.secondary,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: isTablet ? 50 : 10, right: isTablet ? 50 : 10, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.inputLoginDto.name.toUpperCase(),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                            padding: const EdgeInsets.only(top: 8, right: 10),
                            child: Text('Login: ${widget.inputLoginDto.login}',
                                overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14))),
                      ),
                      D3ElevatedButton.primaryOutline(
                          elevation: 0,
                          label: 'Alterar',
                          onPressed: widget.onPressedButtonChange,
                          visualDensity: VisualDensity.compact,
                          color: Theme.of(context).colorScheme.onSurface)
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                      width: double.infinity,
                      child: D3ElevatedButton.primaryOutline(
                          elevation: 0,
                          color: Theme.of(context).colorScheme.onSurface,
                          label: 'Acessar',
                          key: const Key('btnSend'),
                          fontSize: 16,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          onPressed: widget.onPressedButtonAccess,
                          child: widget.childButtonAccess)),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
