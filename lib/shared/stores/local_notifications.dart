import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:meditrack/screens/home/type/medicament.dart';
import 'package:timezone/timezone.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class NotificationService {
  Future<void> initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings(
        'app_icon'); // Substitua 'app_icon' pelo nome do seu ícone de notificação em `android/app/src/main/res/drawable/`

    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        // Lidar com o toque na notificação aqui (ex: navegar para a tela de medicamentos)
        print('Notification payload: ${response.payload}');
      },
    );
  }

  Future<void> scheduleMedicationNotifications(MedicamentRepositoryFire medication) async {
    final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm'); // <<< Formato exato da sua string
    final DateTime startDate = formatter.parse(medication.medicationStartDatetime.trim());
    final DateTime endDate = startDate.add(Duration(days: medication.durationDays));

    DateTime currentScheduledTime = startDate;

    int notificationId =
        medication.medicineId; // Usar medicineId como base para o ID da notificação para evitar conflitos.
    // Considere usar um ID mais robusto como combinação de medicineId e um índice de dose.

    // Limpar notificações antigas para este medicamento
    await flutterLocalNotificationsPlugin.cancel(notificationId);

    while (currentScheduledTime.isBefore(endDate) || currentScheduledTime.isAtSameMomentAs(endDate)) {
      if (currentScheduledTime.isAfter(DateTime.now())) {
        // Agendar a notificação apenas se a hora for no futuro
        const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
          'medication_channel_id', // ID do canal (deve ser único)
          'Lembrete de Medicamento', // Nome do canal
          channelDescription: 'Notificações para lembretes de medicamentos',
          importance: Importance.high,
          priority: Priority.high,
          ticker: 'ticker',
        );

        const DarwinNotificationDetails iOSPlatformChannelSpecifics = DarwinNotificationDetails(
          sound:
              'medication_sound.caf', // Opcional: Adicione um som personalizado (crie 'medication_sound.caf' em 'ios/Runner/Resources/')
        );

        const NotificationDetails platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iOSPlatformChannelSpecifics,
        );

        await flutterLocalNotificationsPlugin.zonedSchedule(
          notificationId, // ID único para a notificação
          'Hora do seu medicamento!',
          'É hora de tomar ${medication.medicineName} (${medication.dosage}) - ${medication.description}.',
          TZDateTime.from(currentScheduledTime, local), // Use o fuso horário local
          platformChannelSpecifics,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time, // Para notificações diárias recorrentes na mesma hora
          payload: medication.id, // Envie o ID do medicamento como payload
        );
        print('Agendada notificação para ${medication.medicineName} em $currentScheduledTime com ID $notificationId');
      }
      currentScheduledTime = currentScheduledTime.add(Duration(hours: medication.dosageIntervalHours));
      notificationId++; // Incrementa o ID para cada dose agendada
    }
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Duration? getTimeUntilNextDose(MedicamentRepositoryFire medication) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm'); // <<< Formato exato da sua string
    final DateTime startDate = formatter.parse(medication.medicationStartDatetime.trim()); // <<< Use o formatter
    final DateTime now = DateTime.now();
    final DateTime endDate = startDate.add(Duration(days: medication.durationDays));

    if (now.isBefore(startDate)) {
      return startDate.difference(now);
    }

    if (now.isAfter(endDate)) {
      return null; // Tratamento finalizado
    }

    DateTime nextDoseTime = startDate;
    while (nextDoseTime.isBefore(now) && nextDoseTime.isBefore(endDate)) {
      nextDoseTime = nextDoseTime.add(Duration(hours: medication.dosageIntervalHours));
    }

    if (nextDoseTime.isAfter(endDate)) {
      return null; // Não há mais doses no período
    }

    return nextDoseTime.difference(now);
  }
}
