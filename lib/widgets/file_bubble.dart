import 'package:flutter/material.dart';
import 'package:lets_talk/models/models.dart';

class FileBubble extends StatelessWidget {
  final Message message;
  const FileBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: 100, maxWidth: 600),
      margin: message.messageType == MessageType.receivedFile
          ? EdgeInsets.only(
              bottom: 8.0,
              right: MediaQuery.of(context).size.width < 800
                  ? MediaQuery.of(context).size.width - 350 //575
                  : MediaQuery.of(context).size.width - 610, //1025,
            )
          : EdgeInsets.only(
              bottom: 8.0,
              left: MediaQuery.of(context).size.width < 800
                  ? MediaQuery.of(context).size.width - 350 //575
                  : MediaQuery.of(context).size.width - 610, //1025,
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
      child: ListTile(
        leading: Container(
          height: 45,
          width: 45,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            // ignore: deprecated_member_use
            color: Theme.of(context).accentColor,
          ),
          child: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.file_download, //Icons.file_copy
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        title: Text(
          message.file?.path.split('\\').last ?? 'There is no file. Why? IDK!',
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${message.file!.lengthSync()} KB',
          style:
              Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 10.0),
        ),
        trailing: Text(
          '${message.time!.hour > 12 ? message.time!.hour - 12 : message.time!.hour}:${message.time!.minute < 10 ? '0' + message.time!.minute.toString() : message.time!.minute} ${message.time!.hour > 12 ? 'PM' : 'AM'}',
          style:
              Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 10.0),
        ),
      ),
    );
  }
}
