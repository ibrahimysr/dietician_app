import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/core/theme/textstyle.dart';
import 'package:dietician_app/client/core/utils/parsing.dart';
import 'package:dietician_app/client/models/goal_model.dart';
import 'package:flutter/material.dart';

class UpdateGoalProgressDialog extends StatefulWidget {
  final Goal goal;
  final Function(double newValue) onSave;

  const UpdateGoalProgressDialog({
    super.key,
    required this.goal,
    required this.onSave,
  });

  @override
  State<UpdateGoalProgressDialog> createState() => _UpdateGoalProgressDialogState();
}

class _UpdateGoalProgressDialogState extends State<UpdateGoalProgressDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _valueController;

  @override
  void initState() {
    super.initState();
    _valueController = TextEditingController(
      text: widget.goal.currentValue?.toStringAsFixed(
            (widget.goal.unit?.toLowerCase() == 'adım' || (widget.goal.currentValue ?? 0) % 1 == 0) ? 0 : 1,
          ) ??
          '',
    );
  }

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final newValue = parseDouble(_valueController.text);
      if (newValue != null) {
        widget.onSave(newValue);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("İlerlemeyi Güncelle"),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.goal.title, style: AppTextStyles.body1Medium, textAlign: TextAlign.center),
              SizedBox(height: 15),
              TextFormField(
                controller: _valueController,
                decoration: InputDecoration(
                  labelText: "Mevcut Değer (${widget.goal.unit ?? ''})",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: !(widget.goal.unit?.toLowerCase() == 'adım')),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Değer gerekli.';
                  final val = parseDouble(value);
                  if (val == null) return 'Geçerli bir sayı girin.';
                  if (val < 0) return 'Değer negatif olamaz.';
                  return null;
                },
                onFieldSubmitted: (_) => _submit(),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("İptal"),
        ),
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(backgroundColor: AppColor.primary, foregroundColor: Colors.white),
          child: Text("Kaydet"),
        ),
      ],
    );
  }
}