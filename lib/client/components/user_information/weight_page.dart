import 'package:flutter/material.dart';
import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/theme/textstyle.dart';
import 'package:dietician_app/client/core/extension/context_extension.dart';
import 'package:numberpicker/numberpicker.dart';

class WeightPicker extends StatelessWidget {
  final double weight;
  final Function(double) onWeightSelected;

  const WeightPicker({super.key, required this.weight, required this.onWeightSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.paddingLow,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Kilonuz Kaç Kg?", style: AppTextStyles.heading2),
          SizedBox(height: context.getDynamicHeight(5)),
          SizedBox(
            height: context.getDynamicHeight(15),
            child: NumberPicker(
              value: weight.round(),
              minValue: 30,
              maxValue: 250,
              step: 1,
              axis: Axis.horizontal,
              itemWidth: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              textStyle: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 22,
              ),
              selectedTextStyle: TextStyle(
                color: AppColor.secondary,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              onChanged: (value) {
                onWeightSelected(value.toDouble());
              },
            ),
          ),
          SizedBox(height: context.getDynamicHeight(2)),
          Container(
            padding: EdgeInsets.symmetric(vertical: context.normalValue, horizontal: context.highValue),
            decoration: BoxDecoration(
              color: AppColor.grey,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${weight.round()} kg",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColor.secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
