import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lets_talk/models/client.dart';
import 'package:lets_talk/models/contact.dart';
import 'package:lets_talk/models/current_chat_model.dart';
import 'package:lets_talk/models/message.dart';
import 'package:lets_talk/widgets/side_bar.dart';
import 'package:lets_talk/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:filepicker_windows/filepicker_windows.dart';
import 'package:dropfiles_window/dropfiles_window.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    Key? key,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ScrollController? _scrollController;
  late FocusNode myFocusNode;
  String message = '';
  File? fileMessage;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    myFocusNode = FocusNode();
    initPlatformState();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    myFocusNode.dispose();
    super.dispose();
  }

  Future<void> initPlatformState() async {
    if (Platform.isWindows == true) {
      // Platform messages may fail, so we use a try/catch PlatformException.
      try {
        DropfilesWindow.modifyWindowAcceptFiles((String strName) {
          print("fileName=$strName");
          fileMessage = File(strName);
          if (fileMessage != null) {
            print(fileMessage!.path);
            context.read<Client>().sendMessage(
                message: fileMessage!.path,
                receiver: context.read<CurrentChatModel>().selected!.name);
            context.read<ContactListModel>().newMessage(
                  context,
                  context.read<CurrentChatModel>().selected!.name,
                  Message(
                    messageType: MessageType.sentFile,
                    sender: 'Self',
                    text: fileMessage!.path,
                    picture: fileMessage!.path.endsWith('.png') ||
                            fileMessage!.path.endsWith('.jpg') ||
                            fileMessage!.path.endsWith('.jpeg')
                        ? fileMessage
                        : null,
                    file: fileMessage,
                  ),
                );
          } else {
            print("Failed to fetch file.");
          }
        });
      } on PlatformException {
        print("Failed to modifyDropFilesWindow.");
      }
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) print("Not mounted!");
  }

  @override
  Widget build(BuildContext context) {
    final contact = context.watch<CurrentChatModel>().selected;
    var msgController = TextEditingController();

    return contact == null
        ? Expanded(
            child: Scaffold(
              backgroundColor: Color(0xFF18191D),
              drawer:
                  MediaQuery.of(context).size.width > 800 ? null : SideBar(),
              appBar: AppBar(
                leadingWidth:
                    MediaQuery.of(context).size.width > 800 ? 200.0 : null,
                backgroundColor: Theme.of(context).primaryColor,
                elevation: 0,
              ),
              body: Center(
                child: Container(
                  height: 27,
                  width: 250,
                  decoration: BoxDecoration(
                    color: Color(0xFF2F343A),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Center(
                    child: Text(
                      'Select a chat to start messaging',
                      style: Theme.of(context).textTheme.bodyText2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          )
        : Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Scaffold(
                    backgroundColor: Color(0xFF18191D),
                    drawer: MediaQuery.of(context).size.width > 800
                        ? null
                        : SideBar(),
                    appBar: AppBar(
                      leadingWidth: MediaQuery.of(context).size.width > 800
                          ? 200.0
                          : null,
                      backgroundColor: Theme.of(context).primaryColor,
                      elevation: 0,
                      title: Center(
                        child: Text(
                          contact.name,
                          style: Theme.of(context)
                              .textTheme
                              .headline2!
                              .copyWith(fontSize: 18.0),
                        ),
                      ),
                    ),
                    body: _ChatMessageView(),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 60.0,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      boxShadow: [BoxShadow(color: Colors.black)]),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: IconButton(
                          onPressed: () {
                            final file = OpenFilePicker()
                              ..filterSpecification = {
                                'Word Document (*.doc)': '*.doc',
                                'Web Page (*.htm; *.html)': '*.htm;*.html',
                                'Text Document (*.txt)': '*.txt',
                                'Picture (*.png; *.jpeg; *.jpg)':
                                    '*.png; *.jpeg; *.jpg',
                                'All Files': '*.*'
                              }
                              ..defaultFilterIndex = 0
                              ..defaultExtension = 'png'
                              ..title = 'Select a file';

                            fileMessage = file.getFile();
                            if (fileMessage != null) {
                              print(fileMessage!.path);
                            }
                            context.read<Client>().sendMessage(
                                message: fileMessage!.path,
                                receiver: contact.name);
                            context.read<ContactListModel>().newMessage(
                                  context,
                                  contact.name,
                                  Message(
                                    messageType: MessageType.sentFile,
                                    sender: 'Self',
                                    text: fileMessage!.path,
                                    picture: fileMessage!.path
                                                .endsWith('.png') ||
                                            fileMessage!.path
                                                .endsWith('.jpg') ||
                                            fileMessage!.path.endsWith('.jpeg')
                                        ? fileMessage
                                        : null,
                                    file: fileMessage,
                                  ),
                                );
                          },
                          icon: Icon(
                            Icons.attach_file,
                            size: 30.0,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ),
                      ),
                      // const Spacer(),
                      Expanded(
                        child: TextField(
                          focusNode: myFocusNode,
                          autofocus: true,
                          controller: msgController,
                          onChanged: (val) {
                            message = val;
                          },
                          onSubmitted: (value) {
                            context.read<Client>().sendMessage(
                                message: value, receiver: contact.name);
                            context.read<ContactListModel>().newMessage(
                                  context,
                                  contact.name,
                                  Message(
                                    messageType: MessageType.sent,
                                    sender: 'Self',
                                    text: value,
                                  ),
                                );
                            msgController.clear();
                            myFocusNode.requestFocus();
                          },
                          // ignore: deprecated_member_use
                          cursorColor: Theme.of(context).accentColor,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintText: 'Write a message...',
                            hintStyle: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(color: Color(0xFF818991)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: IconButton(
                          onPressed: () {
                            context.read<Client>().sendMessage(
                                message: message, receiver: contact.name);
                            context.read<ContactListModel>().newMessage(
                                  context,
                                  contact.name,
                                  Message(
                                    messageType: MessageType.sent,
                                    sender: 'Self',
                                    text: message,
                                  ),
                                );
                            msgController.clear();
                            myFocusNode.requestFocus();
                          },
                          icon: Icon(
                            Icons.send,
                            size: 30.0,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}

class _ChatMessageView extends StatefulWidget {
  const _ChatMessageView({Key? key}) : super(key: key);

  @override
  __ChatMessageViewState createState() => __ChatMessageViewState();
}

class __ChatMessageViewState extends State<_ChatMessageView> {
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contactList = context.watch<ContactListModel>().contactList;
    final selectedChat = context.read<CurrentChatModel>().selected;
    return selectedChat == null
        ? Center(
            child: Container(
              height: 27,
              width: 250,
              decoration: BoxDecoration(
                color: Color(0xFF2F343A),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(
                child: Text(
                  'Select a chat to start messaging',
                  style: Theme.of(context).textTheme.bodyText2,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )
        : Container(
            child: Scrollbar(
              controller: _scrollController,
              child: ListView.builder(
                reverse: true,
                controller: _scrollController,
                padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 8.0),
                physics: ClampingScrollPhysics(),
                itemCount: contactList
                    .where((element) => element.name == selectedChat.name)
                    .first
                    .messsages
                    .length,
                itemBuilder: (BuildContext context, int index) {
                  final message = contactList
                      .where((element) => element.name == selectedChat.name)
                      .first
                      .messsages
                      .reversed
                      .toList()[index];
                  return _buildMessage(message);
                },
              ),
            ),
          );
  }

  _buildMessage(Message message) {
    switch (message.messageType) {
      case MessageType.received:
      case MessageType.sent:
        return ChatBubble(message: message);
      case MessageType.sentFile:
      case MessageType.receivedFile:
        return message.picture != null
            ? PictureBubble(message: message)
            : FileBubble(message: message);
      default:
        return SizedBox.shrink();
    }
  }
}
