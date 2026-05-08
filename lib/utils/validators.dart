// Validators are small reusable functions used by forms.
// Keeping validation here avoids repeating the same checks on many screens.
class Validators {
  static String? requiredText(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? phone(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Mobile number is required';
    if (text.length < 10) return 'Enter a valid mobile number';
    return null;
  }

  static String? upiId(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'UPI ID is required';
    if (!text.contains('@')) return 'UPI ID must contain @';
    if (text.length < 5) return 'Enter a valid UPI ID';
    return null;
  }

  static String? amount(String? value) {
    final amount = double.tryParse(value?.trim() ?? '');
    if (amount == null) return 'Enter a valid amount';
    if (amount <= 0) return 'Amount must be greater than zero';
    if (amount > 100000) return 'Maximum demo amount is ₹1,00,000';
    return null;
  }
}
