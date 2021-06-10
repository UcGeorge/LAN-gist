import 'dart:io';

class Message {
  final sender;
  final text;
  DateTime? time = DateTime.now();
  File? picture;
  File? file;
  MessageType? messageType;

  Message({this.sender, this.text, this.messageType, this.picture, this.file});
}

enum MessageType { sent, received, sentFile, receivedFile }
