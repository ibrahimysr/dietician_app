import 'package:flutter/material.dart';
import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/core/theme/textstyle.dart';
import 'package:dietician_app/core/extension/context_extension.dart';

class HeightPicker extends StatelessWidget {
  final double? height;
  final Function(double) onHeightSelected;

  const HeightPicker({super.key, this.height, required this.onHeightSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.paddingNormalHorizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: context.getDynamicHeight(5)),
          Center(
            child: Text(
              "Boyunuzu Seçin",
              style: AppTextStyles.heading2.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: context.getDynamicHeight(5)),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Row(
              children: [
                _buildEnhancedRuler(context),
                Expanded(
                  child: Center(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColor.grey,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${height!.toInt()}",
                            style: AppTextStyles.heading1.copyWith(
                              color: AppColor.secondary,
                              fontWeight: FontWeight.bold,
                              fontSize: 50,
                            ),
                          ),
                          Text(
                            "cm",
                            style: AppTextStyles.heading1.copyWith(
                              color: AppColor.secondary,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedRuler(BuildContext context) {
    final int minHeight = 120;
    final int maxHeight = 220;
    final int totalHeights = maxHeight - minHeight + 1;

    final double itemHeight = 40.0;
    final double rulerWidth = 120.0;
    final double selectedIndicatorHeight = 60.0;

    FixedExtentScrollController scrollController = FixedExtentScrollController(
      initialItem: (height!.toInt() - minHeight),
    );

    return SizedBox(
      width: rulerWidth,
      child: Stack(
        children: [
          Container(
            width: rulerWidth,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.grey[200]!,
                  Colors.grey[50]!,
                ],
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: (MediaQuery.of(context).size.height * 0.6 - selectedIndicatorHeight) / 2,
            child: Container(
              height: selectedIndicatorHeight,
              decoration: BoxDecoration(
                color: AppColor.secondary.withOpacity(0.2),
                border: Border(
                  top: BorderSide(
                    color: AppColor.secondary,
                    width: 2,
                  ),
                  bottom: BorderSide(
                    color: AppColor.secondary,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
          ListWheelScrollView(
            controller: scrollController,
            physics: const FixedExtentScrollPhysics(),
            perspective: 0.005,
            itemExtent: itemHeight,
            diameterRatio: 2.0,
            onSelectedItemChanged: (index) {
              onHeightSelected(minHeight + index.toDouble());
            },
            children: List.generate(totalHeights, (index) {
              final currentHeight = minHeight + index;
              final isMajorTick = currentHeight % 5 == 0;
              final isLabeledTick = currentHeight % 10 == 0;

              return Container(
                padding: const EdgeInsets.only(left: 10),
                height: itemHeight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: isLabeledTick ? 40 : (isMajorTick ? 25 : 15),
                      height: isLabeledTick ? 3 : (isMajorTick ? 2 : 1),
                      color: currentHeight == height!.toInt()
                          ? AppColor.secondary
                          : (isLabeledTick
                              ? Colors.black87
                              : (isMajorTick ? Colors.black54 : Colors.grey)),
                    ),
                    if (isLabeledTick)
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "$currentHeight",
                          style: TextStyle(
                            fontWeight: currentHeight == height!.toInt()
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 16,
                            color: currentHeight == height!.toInt()
                                ? AppColor.secondary
                                : Colors.black87,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 50,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white,
                    Colors.white.withOpacity(0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 50,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.white,
                    Colors.white.withOpacity(0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
