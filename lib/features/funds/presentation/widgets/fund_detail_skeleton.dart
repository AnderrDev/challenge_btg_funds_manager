import 'package:flutter/material.dart';
import '../../../../core/widgets/skeleton.dart';

class FundDetailSkeleton extends StatelessWidget {
  const FundDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Skeleton(width: 50, height: 24, borderRadius: 20),
              const SizedBox(width: 8),
              const Skeleton(width: 100, height: 24, borderRadius: 20),
            ],
          ),
          const SizedBox(height: 16),
          const Skeleton(width: 250, height: 32),
          const SizedBox(height: 8),
          const Skeleton(width: 180, height: 20),
          const SizedBox(height: 24),
          const Skeleton(width: 120, height: 20),
          const SizedBox(height: 8),
          const Skeleton(width: double.infinity, height: 16),
          const SizedBox(height: 8),
          const Skeleton(width: double.infinity, height: 16),
          const SizedBox(height: 8),
          const Skeleton(width: 200, height: 16),
          const SizedBox(height: 24),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 2.5,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: List.generate(
              4,
              (_) => const Skeleton(borderRadius: 12),
            ),
          ),
          const SizedBox(height: 32),
          const Skeleton(width: double.infinity, height: 54, borderRadius: 12),
        ],
      ),
    );
  }
}
