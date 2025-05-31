import 'package:flutter/material.dart';
import 'package:meditrack/screens/home/settings/components/switch.dart';
import 'package:meditrack/shared/components/med_appbar.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: medAppBar(title: 'Configurações'),
        body: ListView(
          padding: const EdgeInsets.all(10),
          children: const [
            ListTile(
                onTap: null,
                leading: Icon(Icons.mode_night, size: 20),
                title: Text('Modo Escuro', style: TextStyle(fontSize: 14)),
                trailing: SwitchMode()),
            Divider(height: 5),
          ],
        ));
  }
}
