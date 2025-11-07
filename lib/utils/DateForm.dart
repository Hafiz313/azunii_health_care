import 'package:intl/intl.dart';

String formatDate(String isoDate) {
  try {
    // Parse the input ISO date string
    DateTime dateTime = DateTime.parse(isoDate);
    // Format to MM/dd/yyyy
    return DateFormat('MM/dd/yyyy').format(dateTime);
  } catch (e) {
    // Handle invalid date formats
    return 'Invalid Date';
  }
}

String formatDateWithDash(String isoDate) {
  try {
    // Parse the input ISO date string
    DateTime dateTime = DateTime.parse(isoDate);
    // Format to MM/dd/yyyy
    return DateFormat('yyyy-MM-dd').format(dateTime);
  } catch (e) {
    // Handle invalid date formats
    return 'Invalid Date';
  }
}

String getDayOfWeek(String isoDate) {
  try {
    // Parse the input ISO date string
    DateTime dateTime = DateTime.parse(isoDate);
    // Get the short day of the week (e.g., Mon, Tue, Wed)
    return DateFormat('EEE').format(dateTime);
  } catch (e) {
    // Handle invalid date formats
    return 'Invalid Date';
  }
}

String getTime(String isoDate) {
  try {
    // Parse the input ISO date string
    DateTime dateTime = DateTime.parse(isoDate);
    // Get the time in HH:mm format
    return DateFormat('HH:mm').format(dateTime);
  } catch (e) {
    // Handle invalid date formats
    return 'Invalid Time';
  }
}

int findDaysBetweenDates({
  required String startDateString,
  required String endDateString,
}) {
  // Create a DateFormat object with the provided format

  DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  // Parse the string dates into DateTime objects
  DateTime startDate = dateFormat.parse(startDateString);
  DateTime endDate = dateFormat.parse(endDateString);

  // Calculate the difference in days
  return endDate.difference(startDate).inDays;
}

String removeMinus(String input) {
  if (input.startsWith('-')) {
    return input.replaceFirst('-', ''); // Remove the first `-`
  }
  return input;
}
