import 'package:flutter/material.dart';
import 'package:goipvc/models/app_notification.dart';
import 'package:goipvc/ui/widgets/error_message.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // TODO: Replace with actual notifications eventually
  final List<dynamic> _notifications = [
    AppNotification(
      type: 'update',
      title: '0.25.5',
      timestamp: DateTime.now().subtract(Duration(hours: 1)),
    ),
    AppNotification(
      type: 'normal',
      icon: Icons.watch_later,
      topText: 'Aula alterada',
      title: 'IHM',
      subtitle: 'Aula de 5/3/2024 - S 2.4 para A 2.1',
      timestamp: DateTime(2024, 3, 5, 9, 10),
    ),
    AppNotification(
      type: 'normal',
      icon: Icons.school_rounded,
      topText: 'Moodle',
      title: 'Admistração Base de Dados',
      subtitle: 'Nova tarefa',
      timestamp: DateTime(2024, 3, 5, 9, 10),
    ),
    AppNotification(
      type: 'normal',
      icon: Icons.message_rounded,
      topText: 'Moodle',
      title: 'Jorge Ribeiro',
      subtitle: 'AVISO: Está disponível, para o 2.º SEMESTRE é preciso levar',
      timestamp: DateTime(2024, 3, 5, 9, 10),
    )
  ];

  void _removeNotification(int index) {
    setState(() {
      _notifications.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Notificações'),
      ),
      body: _notifications.isEmpty
          ? ErrorMessage(
              icon: Icons.notifications_paused_rounded,
              message: "Sem notificações",
            )
          : ListView.builder(
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                if (notification.type == 'update') {
                  return UpdateNotificationContainer(
                    notification: notification,
                    onUpdate: () {},
                    onChangelog: () {},
                  );
                }

                return NotificationContainer(
                  notification: notification,
                  onDismissed: () => _removeNotification(index),
                );
              },
            ),
    );
  }
}

class NotificationContainer extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onDismissed;

  const NotificationContainer({
    super.key,
    required this.notification,
    required this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) => onDismissed(),
      child: Column(
        children: [
          ListTile(
            leading: Icon(notification.icon, size: 28),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        notification.topText!,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      formatTimestamp(notification.timestamp),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(notification.title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 16,
                    )),
              ],
            ),
            subtitle: Text(
              notification.subtitle!,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Divider(height: 1),
        ],
      ),
    );
  }
}

class UpdateNotificationContainer extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onUpdate;
  final VoidCallback onChangelog;

  const UpdateNotificationContainer({
    super.key,
    required this.notification,
    required this.onUpdate,
    required this.onChangelog,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.system_update_rounded, size: 28),
          isThreeLine: true,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Nova Versão',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    formatTimestamp(notification.timestamp),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                'Versão ${notification.title}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Descarrega a nova versão',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 14,
                  )),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: onUpdate,
                    child: const Text('Changelog'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: onChangelog,
                    icon: Icon(Icons.download_rounded),
                    label: Text('Atualizar'),
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(height: 1),
      ],
    );
  }
}

String formatTimestamp(DateTime timestamp) {
  final now = DateTime.now();
  final notificationDate = timestamp;

  if (notificationDate.year == now.year &&
      notificationDate.month == now.month &&
      notificationDate.day == now.day) {
    return '${notificationDate.hour.toString().padLeft(2, '0')}:${notificationDate.minute.toString().padLeft(2, '0')}';
  } else {
    return '${notificationDate.day.toString().padLeft(2, '0')}/${notificationDate.month.toString().padLeft(2, '0')}';
  }
}
