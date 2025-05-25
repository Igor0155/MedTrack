import 'package:flutter/material.dart';
import 'package:meditrack/main.dart';
import 'package:meditrack/screens/auth/login/components/switch.dart';
import 'package:meditrack/shared/components/d3_elevated_button.dart';
import 'package:meditrack/shared/components/text_form_field.dart';

class EnterCredentials extends StatefulWidget {
  final void Function(String?) onSavedLogin;
  final String? Function(String?) validatorLogin;
  final void Function(String?) onSavedPassword;
  final String? Function(String?) validatorPassword;

  final bool isSaveLoginSwitch;
  final void Function(bool)? onItemSelected;
  final void Function() onPressedButtonAccess;
  final Widget? childButtonAccess;
  final void Function() onPressButtonForgotPassword;

  const EnterCredentials(
      {super.key,
      required this.onSavedLogin,
      required this.validatorLogin,
      required this.onSavedPassword,
      required this.validatorPassword,
      required this.isSaveLoginSwitch,
      required this.onItemSelected,
      required this.onPressedButtonAccess,
      required this.childButtonAccess,
      required this.onPressButtonForgotPassword});

  @override
  State<EnterCredentials> createState() => _EnterCredentialsState();
}

class _EnterCredentialsState extends State<EnterCredentials> {
  final isTablet = getIt.get<bool>(instanceName: 'isTabletDevice');

  bool isSeePassword = false;

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        constraints: const BoxConstraints(maxWidth: 700),
        child: Card(
            margin: const EdgeInsets.only(top: 220),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isTablet ? 50 : 10, vertical: isTablet ? 20 : 10),
              child: Column(
                children: [
                  const Align(
                      alignment: Alignment.center,
                      child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text("Informe suas credenciais",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)))),
                  const SizedBox(height: 10),
                  const Text("MediTrack"),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                          padding: EdgeInsets.only(left: 5, bottom: 5),
                          child: Text('Login', style: TextStyle(fontSize: 14)))),
                  Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: d3TextFormField(
                          onSaved: widget.onSavedLogin, labelText: '', validator: widget.validatorLogin)),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                          padding: EdgeInsets.only(left: 5, bottom: 5),
                          child: Text('Senha', style: TextStyle(fontSize: 14)))),
                  d3TextFormField(
                    labelText: '',
                    key: const Key('InputUserPassword'),
                    onSaved: widget.onSavedPassword,
                    suffixIcon: IconButton(
                      style: ElevatedButton.styleFrom(foregroundColor: const Color(0xffe5e7eb)),
                      icon: isSeePassword
                          ? const Icon(Icons.visibility_off_outlined, color: Color(0xff9ca3af), size: 20)
                          : const Icon(Icons.visibility_outlined, color: Color(0xff9ca3af), size: 20),
                      onPressed: () {
                        setState(() {
                          isSeePassword = !isSeePassword;
                        });
                      },
                    ),
                    obscureText: !isSeePassword,
                    validator: widget.validatorPassword,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Lembrar de mim', style: TextStyle(fontSize: 15)),
                        SwitchSave(isSaveLogin: widget.isSaveLoginSwitch, onItemSelected: widget.onItemSelected)
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: D3ElevatedButton.primary(
                        label: 'Acessar',
                        key: const Key('btnSend'),
                        fontSize: 16,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        onPressed: widget.onPressedButtonAccess,
                        child: widget.childButtonAccess),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                        key: const Key('btnForgotPassword'),
                        onPressed: widget.onPressButtonForgotPassword,
                        child: const Text('Esqueci minha senha')),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
