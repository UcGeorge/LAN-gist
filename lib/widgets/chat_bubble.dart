import 'package:flutter/material.dart';
import 'package:lets_talk/models/models.dart';

class ChatBubble extends StatelessWidget {
  final Message message;
  ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: 100, maxWidth: 600),
      margin: message.messageType == MessageType.received
          ? EdgeInsets.only(
              bottom: 8.0,
              right: MediaQuery.of(context).size.width < 800
                  ? MediaQuery.of(context).size.width - 350
                  : MediaQuery.of(context).size.width - 800,
            )
          : EdgeInsets.only(
              bottom: 8.0,
              left: MediaQuery.of(context).size.width < 800
                  ? MediaQuery.of(context).size.width - 350
                  : MediaQuery.of(context).size.width - 800,
            ),
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
      decoration: BoxDecoration(
        color: message.messageType == MessageType.received
            ? Color(0xFF33393F)
            : Color(0xFF2A2F33),
        borderRadius: message.messageType == MessageType.received
            ? BorderRadius.only(
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              )
            : BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: message.messageType == MessageType.received
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          Text(
            message.text.trim(),
            softWrap: true,
          ),
          const SizedBox(height: 2),
          Text(
            '${message.time!.hour > 12 ? message.time!.hour - 12 : message.time!.hour}:${message.time!.minute < 10 ? '0' + message.time!.minute.toString() : message.time!.minute} ${message.time!.hour > 12 ? 'PM' : 'AM'}',
            style:
                Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 10.0),
          )
        ],
      ),
    );
  }
}
