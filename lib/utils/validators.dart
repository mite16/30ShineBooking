/// Form validators, following the Module 7 pattern: return null when valid,
/// otherwise a short user-facing error message.
class Validators {
  static String? required(String? value, {String field = 'Trường này'}) {
    if (value == null || value.trim().isEmpty) {
      return '$field không được để trống';
    }
    return null;
  }

  static String? email(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Email không được để trống';
    final regex = RegExp(r'^[\w\.\-]+@[\w\-]+\.[a-zA-Z]{2,}$');
    if (!regex.hasMatch(text)) return 'Email không hợp lệ';
    return null;
  }

  static String? phone(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Số điện thoại không được để trống';
    final regex = RegExp(r'^0\d{9}$');
    if (!regex.hasMatch(text)) return 'Số điện thoại phải có 10 số, bắt đầu bằng 0';
    return null;
  }

  static String? password(String? value) {
    final text = value ?? '';
    if (text.isEmpty) return 'Mật khẩu không được để trống';
    if (text.length < 6) return 'Mật khẩu tối thiểu 6 ký tự';
    return null;
  }

  static String? Function(String?) confirmPassword(String Function() original) {
    return (value) {
      if (value == null || value.isEmpty) return 'Vui lòng nhập lại mật khẩu';
      if (value != original()) return 'Mật khẩu nhập lại không khớp';
      return null;
    };
  }
}
