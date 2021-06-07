class Message {
  final sender;
  final text;
  DateTime? time;
  MessageType? messageType;

  Message({this.sender, this.text, this.time, this.messageType});
}

enum MessageType { sent, received, sentFile, receivedFile }
