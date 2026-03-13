import 'package:flutter/material.dart';
import '../../../../core/widgets/skeleton.dart';

class TransactionTileSkeleton extends StatelessWidget {
  const TransactionTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Skeleton(width: 44, height: 44, borderRadius: 12),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Skeleton(width: 150, height: 16),
                  const SizedBox(height: 6),
                  const Skeleton(width: 100, height: 14),
                  const SizedBox(height: 6),
                  const Skeleton(width: 80, height: 12),
                ],
              ),
            ),
            const Skeleton(width: 70, height: 20, borderRadius: 4),
          ],
        ),
      ),
    );
  }
}
