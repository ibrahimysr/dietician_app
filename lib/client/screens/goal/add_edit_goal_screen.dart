import 'package:dietician_app/client/components/shared/custom_app_bar.dart';
import 'package:dietician_app/client/core/utils/parsing.dart';
import 'package:flutter/material.dart';
import 'package:dietician_app/client/models/goal_model.dart';
import 'package:dietician_app/client/core/theme/color.dart';
import 'package:dietician_app/client/services/goal/goal_service.dart'; 
import 'package:dietician_app/client/core/utils/auth_storage.dart'; 
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

  final Map<String, IconData> _categoryIcons = {
    'habit': Icons.repeat,
    'measurement': Icons.straighten,
    'weight': Icons.monitor_weight,
    'nutrition': Icons.restaurant,
    'other': Icons.category,
  };

  final Map<String, Color> _statusColors = {
    'pending': Colors.grey,
    'in_progress': Colors.blue,
    'completed': Colors.green,
    'failed': Colors.red,
    'cancelled': Colors.orange,
  };

  final Map<String, Color> _priorityColors = {
    'low': Colors.green,
    'medium': Colors.orange,
    'high': Colors.red,
  };

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.goal?.title ?? '');
    _descriptionController = TextEditingController(text: widget.goal?.description ?? '');
    _targetValueController = TextEditingController(text: widget.goal?.targetValue?.toString() ?? '');
    _currentValueController = TextEditingController(text: widget.goal?.currentValue?.toString() ?? '');
    _unitController = TextEditingController(text: widget.goal?.unit ?? '');
    _selectedCategory = widget.goal?.category ?? _categories.first;
    _selectedStatus = widget.goal?.status ?? _statuses.first;
    _selectedPriority = widget.goal?.priority ?? _priorities.first;
    _selectedStartDate = widget.goal?.startDate;
    _selectedTargetDate = widget.goal?.targetDate;
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
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColor.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
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
      _showErrorSnackBar("Oturum veya kullanıcı bilgisi bulunamadı.");
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
        _showSuccessSnackBar(response.message);
        Navigator.pop(context, true);
      } else {
        _showErrorSnackBar(response.message);
      }
    } catch (e) {
      if (!mounted) return;
      _showErrorSnackBar("Bir hata oluştu: ${e.toString()}");
    } finally {
      if (mounted) {
        setState(() { _isLoading = false; });
      }
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(8),
      )
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(8),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: CustomAppBar(
        title: _isEditing ? "Hedefi Düzenle" : "Yeni Hedef Ekle",
        
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildSectionHeader('Temel Bilgiler'),
              SizedBox(height: 8),
              _buildTextField(
                controller: _titleController,
                label: 'Hedef Başlığı *',
                icon: Icons.title,
                validator: (value) => (value == null || value.trim().isEmpty) ? 'Başlık gerekli.' : null,
                textCapitalization: TextCapitalization.sentences,
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: _descriptionController,
                label: 'Açıklama',
                icon: Icons.description,
                maxLines: 3,
                hint: 'Hedef hakkında detaylı bilgi girin',
                textCapitalization: TextCapitalization.sentences,
              ),
              SizedBox(height: 24),
              
              _buildSectionHeader('Ölçüm Detayları'),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _targetValueController,
                      label: 'Hedef Değer',
                      icon: Icons.flag,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _currentValueController,
                      label: 'Mevcut Değer',
                      icon: Icons.trending_up,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: _unitController,
                label: 'Birim',
                icon: Icons.straighten,
                hint: 'örn: kg, adım, cm, %',
              ),
              SizedBox(height: 24),
              
              _buildSectionHeader('Kategori ve Durum'),
              SizedBox(height: 8),
              _buildCategoryDropdown(),
              SizedBox(height: 16), 
               _buildStatusDropdown(), 
                             SizedBox(height: 16), 

               _buildPriorityDropdown(),
              
              SizedBox(height: 24),
              
              _buildSectionHeader('Zaman Çizelgesi'),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildDatePickerField(
                      context: context,
                      label: "Başlangıç Tarihi",
                      selectedDate: _selectedStartDate,
                      onTap: () => _selectDate(context, true),
                      icon: Icons.event,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildDatePickerField(
                      context: context,
                      label: "Hedef Tarih",
                      selectedDate: _selectedTargetDate,
                      onTap: () => _selectDate(context, false),
                      icon: Icons.event_available,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              
              _buildSaveButton(),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColor.secondary,
          ),
        ),
        SizedBox(height: 4),
        Divider(color: AppColor.secondary, thickness: 1),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColor.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColor.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red, width: 1),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      textCapitalization: textCapitalization,
    );
  }

  Widget _buildCategoryDropdown() {
    
    return DropdownButtonFormField<String>( 
       dropdownColor: Colors.white,
    iconEnabledColor: AppColor.primary,
    elevation: 8,
    menuMaxHeight: 300,
    isDense: true,
      value: _selectedCategory,
      decoration: InputDecoration(
        labelText: 'Kategori *',
        prefixIcon: Icon(
          _selectedCategory != null ? _categoryIcons[_selectedCategory] ?? Icons.category : Icons.category,
          color: AppColor.primary,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColor.primary, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
      items: _categories.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Row(
            children: [
              Icon(_categoryIcons[item] ?? Icons.category, color: AppColor.primary, size: 20),
              SizedBox(width: 8),
              Text(_getCategoryText(item)),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) => setState(() => _selectedCategory = value),
      validator: (val) => (val == null) ? 'Kategori seçimi gerekli.' : null,
    );
  }

  Widget _buildStatusDropdown() {
    return DropdownButtonFormField<String>(
       dropdownColor: Colors.white,
    iconEnabledColor: AppColor.primary,
    elevation: 8,
    menuMaxHeight: 300,
    isDense: true,
      value: _selectedStatus,
      decoration: InputDecoration(
        labelText: 'Durum *',
        prefixIcon: Icon(Icons.hourglass_empty, color: _selectedStatus != null ? _statusColors[_selectedStatus] : AppColor.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColor.primary, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        
      ),
      items: _statuses.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: _statusColors[item] ?? Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8),
              Text(_getStatusText(item)),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) => setState(() => _selectedStatus = value),
      validator: (val) => (val == null) ? 'Durum seçimi gerekli.' : null,
    );
  }

 Widget _buildPriorityDropdown() {
  return DropdownButtonFormField<String>(
    value: _selectedPriority,
    decoration: InputDecoration(
      labelText: 'Öncelik',
      prefixIcon: Icon(Icons.priority_high, color: _selectedPriority != null ? _priorityColors[_selectedPriority] : AppColor.primary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColor.primary, width: 2),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    ),
    dropdownColor: Colors.white,
    iconEnabledColor: AppColor.primary,
    elevation: 8,
    menuMaxHeight: 300,
    isDense: true,
    style: TextStyle(
      color: Colors.black87,
      fontSize: 16,
    ),
    items: _priorities.map((String item) {
      return DropdownMenuItem<String>(
        value: item,
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: _priorityColors[item] ?? Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 8),
            Text(item.capitalize()),
          ],
        ),
      );
    }).toList(),
    onChanged: (value) => setState(() => _selectedPriority = value),
  );
}

  Widget _buildDatePickerField({
    required BuildContext context,
    required String label,
    required DateTime? selectedDate,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Row(
          children: [
            SizedBox(width: 12),
            Icon(icon, color: AppColor.primary),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    selectedDate == null
                        ? 'Tarih Seç'
                        : DateFormat('dd.MM.yyyy').format(selectedDate),
                    style: TextStyle(
                      fontSize: 16,
                      color: selectedDate == null ? Colors.grey.shade600 : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_drop_down, color: AppColor.primary),
            SizedBox(width: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _saveGoal,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.primary,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_isLoading)
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 2,
              ),
            )
          else
            Icon(_isEditing ? Icons.update : Icons.add_circle_outline),
          SizedBox(width: 12),
          Text(
            _isLoading
                ? "Kaydediliyor..."
                : (_isEditing ? "Hedefi Güncelle" : "Hedefi Oluştur"),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
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

  String _getCategoryText(String category) {
    switch(category.toLowerCase()){
      case 'habit': return "Alışkanlık";
      case 'measurement': return "Ölçüm";
      case 'weight': return "Kilo";
      case 'nutrition': return "Beslenme";
      case 'other': return "Diğer";
      default: return category;
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return "";
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}