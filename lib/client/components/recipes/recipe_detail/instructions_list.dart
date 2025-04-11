import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/theme/textstyle.dart';
import 'package:flutter/material.dart';

class InstructionsList extends StatelessWidget {
  final String instructions;

  const InstructionsList({super.key, required this.instructions});

  @override
  Widget build(BuildContext context) {
    final instructionsList = instructions
        .split('\n')
        .where((line) => line.trim().isNotEmpty)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: instructionsList.asMap().entries.map((entry) {
        final index = entry.key;
        final instruction = entry.value.trim();

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${index + 1}.',
                style: AppTextStyles.heading4.copyWith(
                  color: AppColor.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  instruction,
                  style: AppTextStyles.body1Regular.copyWith(
                    color: AppColor.black,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}