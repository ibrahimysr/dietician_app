import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/models/food_log_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditLogDialog extends StatefulWidget {
  final FoodLog logToEdit;
  final Function(Map<String, dynamic> updatedData) onUpdate;

  const EditLogDialog({
    super.key,
    required this.logToEdit,
    required this.onUpdate,
  });

  @override
  State<EditLogDialog> createState() => _EditLogDialogState();
}

class _EditLogDialogState extends State<EditLogDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descriptionController;
  late TextEditingController _quantityController;
  late TextEditingController _caloriesController;
  late TextEditingController _proteinController;
  late TextEditingController _fatController;
  late TextEditingController _carbsController;
  late DateTime _editedLoggedAt;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: widget.logToEdit.foodDescription ?? '');
    _quantityController = TextEditingController(text: widget.logToEdit.quantity);
    _caloriesController = TextEditingController(text: widget.logToEdit.calories.toString());
    _proteinController = TextEditingController(text: widget.logToEdit.protein ?? '');
    _fatController = TextEditingController(text: widget.logToEdit.fat ?? '');
    _carbsController = TextEditingController(text: widget.logToEdit.carbs ?? '');
    _editedLoggedAt = DateTime.parse(widget.logToEdit.loggedAt).toLocal();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _quantityController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _fatController.dispose();
    _carbsController.dispose();
    super.dispose();
  }

  void _handleDateTimeChange() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _editedLoggedAt,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(Duration(days: 1)),
      locale: const Locale('tr', 'TR'),
    );
    if (selectedDate == null) return;

    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_editedLoggedAt),
    );
    if (selectedTime == null) return;

    setState(() {
      _editedLoggedAt = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );
    });
  }

  void _submitUpdate() {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> updatedData = {
        'food_description': _descriptionController.text.trim(),
        'quantity': double.parse(_quantityController.text.replaceAll(',', '.')),
        'calories': int.parse(_caloriesController.text),
        'logged_at': _editedLoggedAt,
        if (_proteinController.text.isNotEmpty) 'protein': double.parse(_proteinController.text.replaceAll(',', '.')),
        if (_fatController.text.isNotEmpty) 'fat': double.parse(_fatController.text.replaceAll(',', '.')),
        if (_carbsController.text.isNotEmpty) 'carbs': double.parse(_carbsController.text.replaceAll(',', '.')),
      };
      widget.onUpdate(updatedData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Kaydı Düzenle"),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Yemek Açıklaması *'),
                validator: (v) => (v == null || v.isEmpty) ? 'Gerekli' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: 'Miktar *', suffixText: 'porsiyon'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Gerekli';
                  if (double.tryParse(v.replaceAll(',', '.')) == null || double.parse(v.replaceAll(',', '.')) <= 0) {
                    return 'Geçersiz';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _caloriesController,
                decoration: InputDecoration(labelText: 'Kalori (kcal) *'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Gerekli';
                  if (int.tryParse(v) == null || int.parse(v) < 0) return 'Geçersiz';
                  return null;
                },
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _proteinController,
                      decoration: InputDecoration(labelText: 'Prot (g)'),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _fatController,
                      decoration: InputDecoration(labelText: 'Yağ (g)'),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _carbsController,
                      decoration: InputDecoration(labelText: 'Karb (g)'),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text("Yenme Zamanı:"),
                subtitle: Text(DateFormat('dd MMMM yyyy, HH:mm', 'tr_TR').format(_editedLoggedAt)),
                trailing: Icon(Icons.edit_calendar, color: AppColor.secondary),
                onTap: _handleDateTimeChange,
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('İptal'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColor.primary, foregroundColor: AppColor.white),
          onPressed: _submitUpdate,
          child: Text('Güncelle'),
        ),
      ],
    );
  }
}