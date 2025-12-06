import 'package:flutter/material.dart';

/// Displays availability status as a small chip/indicator.
class AvailabilityIndicator extends StatelessWidget {
  const AvailabilityIndicator({
    super.key,
    required this.isAvailable,
    this.label,
  });

  final bool isAvailable;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = isAvailable ? Colors.green : colorScheme.error;
    final text = label ?? (isAvailable ? 'Available' : 'Unavailable');

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.circle, size: 10, color: color),
        const SizedBox(width: 6),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }
}
