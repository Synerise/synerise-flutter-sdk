class SyneriseUtils {
  static DateTime formatIntToDateTime(int timestampInMiliseconds) {
    DateTime dateTime;
    dateTime = DateTime.fromMillisecondsSinceEpoch(timestampInMiliseconds, isUtc: true);
    return dateTime;
  }
}
