import 'package:flutter/material.dart';
import '../../../../core/widgets/skeleton.dart';

class FundCardSkeleton extends StatelessWidget {
  const FundCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Skeleton(width: 60, height: 24, borderRadius: 20),
                const Spacer(),
                const Skeleton(width: 80, height: 24, borderRadius: 20),
              ],
            ),
            const SizedBox(height: 12),
            const Skeleton(width: 200, height: 24),
            const SizedBox(height: 8),
            const Skeleton(width: 150, height: 18),
            const SizedBox(height: 16),
            const Skeleton(width: double.infinity, height: 40, borderRadius: 8),
            const SizedBox(height: 8),
            const Center(
              child: Skeleton(width: 80, height: 12),
            ),
          ],
        ),
      ),
    );
  }
}
