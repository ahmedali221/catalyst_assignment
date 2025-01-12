import 'package:intl/intl.dart';

final String userUrl = 'https://test.catalystegy.com/api/users';
final String propertiesUrl = 'https://test.catalystegy.com/api/properties';
final String bookingsUrl = 'https://test.catalystegy.com/api/bookings';
final String updateUrl = 'https://test.catalystegy.com/api/properties';

//Date Formatter
String formatDateToDayMonth(DateTime dateString) {
  return DateFormat('d MMMM y').format(dateString);
}
