import 'package:intl/intl.dart';

String numberFormatter(num? value) {
  if (value == null) {
    return "";
  }
  final formatter = NumberFormat("#,###", "ru_RU");
  final formattingNumber = formatter.format(value);
  print(formattingNumber);
  return formattingNumber;
}

// String cardPanFormatter(String? value) {
//   if (value == null) {
//     return "";
//   }
//   final formatter = ("#,####", "ru_RU");
//   final formattingNumber = formatter.format(value);
//   print(formattingNumber);
//   return formattingNumber;
// }
