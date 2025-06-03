import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditrack/screens/home/components/modal_options.dart';
import 'package:meditrack/screens/home/state.dart';
import 'package:meditrack/shared/components/snackbar_message.dart';
import 'package:meditrack/shared/stores/local_notifications.dart';

class ListViewMedicament extends ConsumerStatefulWidget {
  final MedicamentStateNotifier state;
  final bool isTablet;

  const ListViewMedicament({super.key, required this.state, required this.isTablet});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ListViewWorkspaceState();
}

class _ListViewWorkspaceState extends ConsumerState<ListViewMedicament> {
  final NotificationService _notificationService = NotificationService();

  String _formatDuration(Duration? duration) {
    if (duration == null) {
      return 'Tratamento Concluído';
    }
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitHours = twoDigits(duration.inHours.remainder(24));
    if (duration.inDays > 0) {
      return '${duration.inDays}d ${twoDigitHours}h ${twoDigitMinutes}m';
    } else if (duration.inHours > 0) {
      return '${twoDigitHours}h ${twoDigitMinutes}m';
    } else {
      return '${twoDigits(duration.inSeconds.remainder(60))}s';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: widget.state.list?.length ?? 0,
        itemBuilder: (context, index) {
          final medication = widget.state.list![index];
          final timeUntilNextDose = _notificationService.getTimeUntilNextDose(medication);
          return Container(
            margin: widget.isTablet
                ? const EdgeInsets.only(left: 28, right: 28, top: 4, bottom: 8)
                : const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 8),
            child: Ink(
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(12.0),
                border: Border(left: BorderSide(color: Theme.of(context).primaryColor, width: 4.0)),
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).shadowColor.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(0, 1)),
                ],
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () async {
                  var result = await ShowModalOptions().modalViewOptions(medication, context);
                  if (result == null || !context.mounted) return;
                  if (result == TypeModalOptions.delete) {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Confirmação'),
                        content: Text('Tem certeza que deseja remover ${medication.medicineName}?'),
                        actions: [
                          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancelar')),
                          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Remover')),
                        ],
                      ),
                    );
                    if (confirm != true || !context.mounted) return;
                    await widget.state.remove(medication);
                    if (!context.mounted) return;

                    context.showSnackBarSuccess("Medicamento ${medication.medicineName} removido com sucesso!");
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(medication.medicineName,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text(medication.medicineName,
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text(medication.formaFarm, style: const TextStyle(fontSize: 12)),
                            if (timeUntilNextDose != null)
                              Text('Próxima dose em: ${_formatDuration(timeUntilNextDose)}',
                                  style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.blue))
                            else
                              const Text('Tratamento concluído ou não iniciado.',
                                  style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
                          ],
                        ),
                      ),
                      const Icon(Icons.restore, size: 32, color: Colors.redAccent)
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
