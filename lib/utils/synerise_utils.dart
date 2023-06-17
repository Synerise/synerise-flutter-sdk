class SyneriseUtils {
  /// This function converts a timestamp in milliseconds to a DateTime object in UTC format.
  ///
  /// Args:
  ///   timestampInMiliseconds (int): timestampInMiliseconds is an integer value representing the number
  /// of milliseconds since the Unix epoch (January 1, 1970, 00:00:00 UTC).
  ///
  /// Returns:
  ///   The function `formatIntToDateTime` returns a `DateTime` object that represents the date and time
  /// corresponding to the input `timestampInMiliseconds`.
  static DateTime formatIntToDateTime(int timestampInMiliseconds) {
    DateTime dateTime;
    dateTime = DateTime.fromMillisecondsSinceEpoch(timestampInMiliseconds, isUtc: true);
    return dateTime;
  }
}
