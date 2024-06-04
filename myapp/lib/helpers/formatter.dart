import 'package:intl/intl.dart';

class Formatter {
  static String formatDate(DateTime? date) {
    date ??= DateTime.now();
    return DateFormat('dd-MM-yyyy').format(date);
  }

  static String formatPhoneNumber(String phoneNumber) {
    // Check if the phone number has 10 digits
    if (phoneNumber.length == 10) {
      // Format: (0XX) XXX-XXXX
      return '(${phoneNumber.substring(0, 3)}) ${phoneNumber.substring(3, 6)}-${phoneNumber.substring(6)}';
    }
    // Return the original phone number if it doesn't match the expected length
    return phoneNumber;
  }

}
