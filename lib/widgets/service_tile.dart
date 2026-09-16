import 'package:flutter/material.dart';

import '../models/service_item.dart';
import '../utils/formatters.dart';

class ServiceTile extends StatelessWidget {
  const ServiceTile({
    super.key,
    required this.service,
    required this.selected,
    required this.onChanged,
  });

  final ServiceItem service;
  final bool selected;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: CheckboxListTile(
        value: selected,
        onChanged: onChanged,
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(service.name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(service.description),
            const SizedBox(height: 4),
            Text(
              '${Formatters.currency(service.priceVnd)} · ${Formatters.duration(service.durationMinutes)}',
              style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
