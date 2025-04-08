
import 'package:dietician_app/core/utils/parsing.dart';
import 'package:flutter/material.dart';
import 'package:dietician_app/models/goal_model.dart';
import 'package:dietician_app/core/theme/color.dart';
import 'package:dietician_app/services/goal/goal_service.dart'; 
import 'package:dietician_app/core/utils/auth_storage.dart'; 
import 'package:intl/intl.dart'; 

class AddEditGoalScreen extends StatefulWidget {
  final Goal? goal; 
  final int dietitianId;

  const AddEditGoalScreen({super.key, this.goal, required this.dietitianId});

  @override
  State<AddEditGoalScreen> createState() => _AddEditGoalScreenState();
}

class _AddEditGoalScreenState extends State<AddEditGoalScreen> {
  final _formKey = GlobalKey<FormState>();
  final GoalService _goalService = GoalService(); 
  bool get _isEditing => widget.goal != null;
  bool _isLoading = false;

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _targetValueController;
  late TextEditingController _currentValueController;
  late TextEditingController _unitController;

  String? _selectedCategory;
  String? _selectedStatus;
  String? _selectedPriority;
  DateTime? _selectedStartDate;
  DateTime? _selectedTargetDate;

  final List<String> _categories = ['habit', 'measurement', 'weight', 'nutrition', 'other'];
  final List<String> _statuses = ['pending', 'in_progress', 'completed', 'failed', 'cancelled'];
  final List<String> _priorities = ['low', 'medium', 'high'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.goal?.title ?? '');
    _descriptionController = TextEditingController(text: widget.goal?.description ?? '');
    _targetValueController = TextEditingController(text: widget.goal?.targetValue?.toString() ?? '');
    _currentValueController = TextEditingController(text: widget.goal?.currentValue?.toString() ?? '');
    _unitController = TextEditingController(text: widget.goal?.unit ?? '');
    _selectedCategory = widget.goal?.category;
    _selectedStatus = widget.goal?.status;
    _selectedPriority = widget.goal?.priority;
    _selectedStartDate = widget.goal?.startDate;
    _selectedTargetDate = widget.goal?.targetDate;

     if (_selectedCategory == null && _categories.isNotEmpty) _selectedCategory = _categories.first;
     if (_selectedStatus == null && _statuses.isNotEmpty) _selectedStatus = _statuses.first;
     if (_selectedPriority == null && _priorities.isNotEmpty) _selectedPriority = _priorities.first;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _targetValueController.dispose();
    _currentValueController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
     final DateTime initial = (isStartDate ? _selectedStartDate : _selectedTargetDate) ?? DateTime.now();
     final DateTime first = DateTime(2020);
     final DateTime last = DateTime(2101);

     final DateTime? picked = await showDatePicker(
       context: context,
       initialDate: initial,
       firstDate: first,
       lastDate: last,
       locale: const Locale('tr', 'TR'),
     );

     if (picked != null) {
       setState(() {
         if (isStartDate) {
           _selectedStartDate = picked;
           if (_selectedTargetDate != null && _selectedTargetDate!.isBefore(picked)) {
             _selectedTargetDate = picked;
           }
         } else {
           _selectedTargetDate = picked;
            if (_selectedStartDate != null && _selectedStartDate!.isAfter(picked)) {
             _selectedStartDate = picked;
           }
         }
       });
     }
   }


  Future<void> _saveGoal() async {
    if (!_formKey.currentState!.validate()) {
      return; 
    }
    if (_isLoading) return; 

    setState(() { _isLoading = true; });

    final token = await AuthStorage.getToken();
    final clientId = await AuthStorage.getId();
     if (token == null || clientId == null) {
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Oturum veya kullanıcı bilgisi bulunamadı."), backgroundColor: Colors.red));
       setState(() { _isLoading = false; });
       return;
     }


    Map<String, dynamic> goalData = {
      'client_id': clientId,
      'dietitian_id': widget.dietitianId,
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'target_value': parseDouble(_targetValueController.text),
      'current_value': parseDouble(_currentValueController.text),
      'unit': _unitController.text.trim(),
      'category': _selectedCategory,
      if (_selectedStartDate != null) 'start_date': DateFormat('yyyy-MM-dd').format(_selectedStartDate!),
      if (_selectedTargetDate != null) 'target_date': DateFormat('yyyy-MM-dd').format(_selectedTargetDate!),
      'status': _selectedStatus,
      'priority': _selectedPriority,
    };

    goalData.removeWhere((key, value) =>
        value == null ||
        (value is String && value.isEmpty && ['title', 'category', 'status'].contains(key) == false) 
    );


    try {
      dynamic response; 

      if (_isEditing) {
        response = await _goalService.updateGoal(
          token: token,
          goalId: widget.goal!.id,
          updateData: goalData,
        );
      } else {
        response = await _goalService.addGoal(
          token: token,
          goalData: goalData,
        );
      }

       if (!mounted) return;

       if (response.success) {
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text(response.message), backgroundColor: Colors.green)
          );
          Navigator.pop(context, true);
       } else {
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text(response.message), backgroundColor: Colors.red)
          );
       }

    } catch (e) {
       if (!mounted) return;
       ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Bir hata oluştu: ${e.toString()}"), backgroundColor: Colors.red)
       );
    } finally {
       if (mounted) {
          setState(() { _isLoading = false; });
       }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? "Hedefi Düzenle" : "Yeni Hedef Ekle"),
        backgroundColor: AppColor.primary,
        foregroundColor: Colors.white,
        actions: [
          if (_isLoading) Padding(padding: const EdgeInsets.only(right: 16.0), child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))))
          else IconButton(icon: Icon(Icons.save), tooltip: "Kaydet", onPressed: _saveGoal)
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Hedef Başlığı *', border: OutlineInputBorder()),
              validator: (value) => (value == null || value.trim().isEmpty) ? 'Başlık gerekli.' : null,
              textCapitalization: TextCapitalization.sentences,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Açıklama', border: OutlineInputBorder()),
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
            ),
            SizedBox(height: 16),
             Row(
               children: [
                 Expanded(
                   child: TextFormField(
                      controller: _targetValueController,
                     decoration: InputDecoration(labelText: 'Hedef Değer', border: OutlineInputBorder()),
                     keyboardType: TextInputType.numberWithOptions(decimal: true),
                   ),
                 ),
                  SizedBox(width: 10),
                 Expanded(
                   child: TextFormField(
                     controller: _currentValueController,
                     decoration: InputDecoration(labelText: 'Mevcut Değer', border: OutlineInputBorder()),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                   ),
                 ),
               ],
             ),
              SizedBox(height: 16),
              TextFormField(
                 controller: _unitController,
                decoration: InputDecoration(labelText: 'Birim (örn: kg, adım, cm, %)', border: OutlineInputBorder()),
              ),
             SizedBox(height: 16),
              _buildDropdown<String>(
                 label: 'Kategori *',
                 value: _selectedCategory,
                 items: _categories,
                 onChanged: (value) => setState(() => _selectedCategory = value),
                 itemText: (item) => item, 
              ),
               SizedBox(height: 16),
               _buildDropdown<String>(
                 label: 'Durum *',
                 value: _selectedStatus,
                 items: _statuses,
                 onChanged: (value) => setState(() => _selectedStatus = value),
                 itemText: (item) => _getStatusText(item), 
               ),
                SizedBox(height: 16),
                _buildDropdown<String>(
                 label: 'Öncelik', 
                 value: _selectedPriority,
                 items: _priorities,
                 onChanged: (value) => setState(() => _selectedPriority = value),
                 itemText: (item) => item.capitalize(), 
               ),
               SizedBox(height: 16),
               Row(
                 children: [
                    Expanded(
                       child: _buildDatePickerField(
                          context: context,
                          label: "Başlangıç Tarihi",
                          selectedDate: _selectedStartDate,
                          onTap: () => _selectDate(context, true)
                       ),
                    ),
                     SizedBox(width: 10),
                     Expanded(
                       child: _buildDatePickerField(
                          context: context,
                          label: "Hedef Tarih",
                          selectedDate: _selectedTargetDate,
                          onTap: () => _selectDate(context, false)
                       ),
                    ),
                 ],
               ),

            SizedBox(height: 30),
            ElevatedButton.icon(
               icon: Icon(_isLoading ? Icons.hourglass_empty : Icons.save),
               label: Text(_isLoading ? "Kaydediliyor..." : (_isEditing ? "Güncelle" : "Oluştur")),
               onPressed: _isLoading ? null : _saveGoal, 
               style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14)
               ),
            )
          ],
        ),
      ),
    );
  }

   Widget _buildDropdown<T>({
     required String label,
     required T? value,
     required List<T> items,
     required ValueChanged<T?> onChanged,
     required String Function(T) itemText, 
     String? hint,
   }) {
     return DropdownButtonFormField<T>(
       value: value,
       hint: hint != null ? Text(hint) : null,
       decoration: InputDecoration(
         labelText: label,
         border: OutlineInputBorder(),
         contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16)
       ),
       items: items.map((T item) {
         return DropdownMenuItem<T>(
           value: item,
           child: Text(itemText(item)),
         );
       }).toList(),
       onChanged: onChanged,
        validator: (val) => (val == null && label.endsWith('*')) ? 'Bu alan gerekli.' : null,
     );
   }

  Widget _buildDatePickerField({
    required BuildContext context,
    required String label,
    required DateTime? selectedDate,
    required VoidCallback onTap,
  }) {
     return InkWell(
       onTap: onTap,
       child: InputDecorator(
         decoration: InputDecoration(
           labelText: label,
           border: OutlineInputBorder(),
           contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
         ),
         child: Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: <Widget>[
             Text(
               selectedDate == null
                   ? 'Tarih Seç'
                   : DateFormat('dd.MM.yyyy').format(selectedDate),
                 style: TextStyle(color: selectedDate == null ? Colors.grey.shade600 : Colors.black87),
             ),
             Icon(Icons.calendar_today, color: AppColor.primary, size: 20),
           ],
         ),
       ),
     );
   }

    String _getStatusText(String status) {
      switch(status.toLowerCase()){
        case 'in_progress': return "Devam Ediyor";
        case 'pending': return "Beklemede";
        case 'completed': return "Tamamlandı";
        case 'failed': return "Başarısız";
        case 'cancelled': return "İptal Edildi";
        default: return status;
     }
   }
}


extension StringExtension on String {
    String capitalize() {
      if (this.isEmpty) return "";
      return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
    }
}