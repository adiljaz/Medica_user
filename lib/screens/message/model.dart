class Message {
  final String senderid;
  final String senderEmail;
  final String reciverId;
  final String message;
  final String timeStamp;
  Message({
    required this.senderid,
    required this.senderEmail,
    required this.message,
    required this.timeStamp,
    required this.reciverId,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderid,
      "senderEmail": senderEmail,
      'reciverId': reciverId,
      'timeStamp': timeStamp,
      'message': message,
    };
  }
}
