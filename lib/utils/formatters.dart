import 'package:intl/intl.dart';

class Formatters {
  static final _currency = NumberFormat.decimalPattern('vi_VN');
  static final _date = DateFormat('EEEE, dd/MM/yyyy', 'vi_VN');
  static final _dateShort = DateFormat('dd/MM/yyyy');

  static String currency(int vnd) => '${_currency.format(vnd)}đ';

  static String date(DateTime date) {
    try {
      return _date.format(date);
    } catch (_) {
      return _dateShort.format(date);
    }
  }

  static String dateShort(DateTime date) => _dateShort.format(date);

  static String duration(int minutes) {
    if (minutes < 60) return '$minutes phút';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return m == 0 ? '$h giờ' : '$h giờ $m phút';
  }
}
