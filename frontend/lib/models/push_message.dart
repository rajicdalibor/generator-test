class PushMessage {
  bool? dryRun;
  String title;
  List<String>? titleArgs;
  String? subtitle;
  List<String>? subtitleArgs;

  String body;
  List<String>? bodyArgs;
  String userId;
  Map<String, String>? data;

  PushMessage({
    this.dryRun,
    required this.title,
    this.titleArgs,
    this.subtitle,
    this.subtitleArgs,
    required this.body,
    this.bodyArgs,
    required this.userId,
    this.data,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonData = {
      PushMessageConstants.dryRun: dryRun,
      PushMessageConstants.title: title,
      PushMessageConstants.titleArgs: titleArgs,
      PushMessageConstants.subtitle: subtitle,
      PushMessageConstants.subtitleArgs: subtitleArgs,
      PushMessageConstants.body: body,
      PushMessageConstants.bodyArgs: bodyArgs,
      PushMessageConstants.userId: userId,
      PushMessageConstants.data: data,
    };
    jsonData.removeWhere((key, value) => value == null);
    return jsonData;
  }
}

enum NotificationMessages {
  // ignore: constant_identifier_names
  TEST_NOTIFICATION_TITLE,
  // ignore: constant_identifier_names
  TEST_NOTIFICATION_SUBTITLE,
  // ignore: constant_identifier_names
  TEST_NOTIFICATION_BODY,
}

class PushMessageConstants {
  static const String dryRun = 'dryRun';
  static const String title = 'title';
  static const String titleArgs = 'titleArgs';
  static const String subtitle = 'subtitle';
  static const String subtitleArgs = 'subtitleArgs';
  static const String body = 'body';
  static const String bodyArgs = 'bodyArgs';
  static const String userId = 'userId';
  static const String data = 'data';
}
