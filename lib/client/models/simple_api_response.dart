class SimpleApiResponse {
  final bool success;
  final String message;

  SimpleApiResponse({required this.success, required this.message});

  factory SimpleApiResponse.fromJson(Map<String, dynamic> json) {
    return SimpleApiResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? 'İşlem durumu bilinmiyor.',
    );
  }
}