import 'package:flutter/material.dart';
import 'package:lets_talk/models/models.dart';

class PictureBubble extends StatelessWidget {
  final Message message;

  const PictureBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: 100, maxWidth: 600),
      margin: message.messageType == MessageType.receivedFile
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
      padding: EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: message.messageType == MessageType.receivedFile
            ? Color(0xFF33393F)
            : Color(0xFF2A2F33),
        borderRadius: message.messageType == MessageType.receivedFile
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
      child: ClipRRect(
        borderRadius: message.messageType == MessageType.receivedFile
            ? BorderRadius.only(
                topRight: Radius.circular(8),
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              )
            : BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
        child: Image.file(
          message.picture!,
          fit: BoxFit.fitWidth,
          errorBuilder: (
            BuildContext context,
            Object error,
            StackTrace? stackTrace,
          ) {
            return Container(
              color: Colors.grey,
              width: double.infinity,
              height: double.infinity,
              child: const Center(
                child:
                    const Text('Error load image', textAlign: TextAlign.center),
              ),
            );
          },
        ),
      ),
    );
  }
}
