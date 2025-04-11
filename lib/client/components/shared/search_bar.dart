import 'package:dietician_app/client/core/theme/color.dart';
import 'package:flutter/material.dart';

Widget buildSearchBar() {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), color: AppColor.grey),
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
      onChanged: (value) {},
    ),
  );
}