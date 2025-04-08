import 'package:dietician_app/core/theme/color.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final Function(String) onChanged;

  const SearchBar({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColor.grey,
      ),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: "Diyet planı ara...",
          prefixIcon: Icon(Icons.search, color: AppColor.primary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        ),
        onChanged: onChanged,
      ),
    );
  }
}