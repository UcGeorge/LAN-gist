import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lets_talk/models/client.dart';
import 'package:lets_talk/models/contact.dart';
import 'package:lets_talk/models/current_chat_model.dart';
import 'package:lets_talk/models/message.dart';
import 'package:lets_talk/widgets/side_bar.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    myFocusNode.dispose();
    super.dispose();
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
                          onPressed: () {},
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
                                    time: DateTime.now(),
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
                                    time: DateTime.now(),
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
        return ChatBubble(
            messageType: MessageType.received,
            text: message.text,
            time: message.time ?? DateTime.now());
      case MessageType.sent:
        return ChatBubble(
            messageType: MessageType.sent,
            text: message.text,
            time: message.time ?? DateTime.now());
      default:
        return SizedBox.shrink();
    }
  }
}

class ChatBubble extends StatelessWidget {
  final MessageType messageType;
  final String text;
  final DateTime time;
  const ChatBubble(
      {Key? key,
      required this.messageType,
      required this.text,
      required this.time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: 100, maxWidth: 600),
      margin: messageType == MessageType.received
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
        color: messageType == MessageType.received
            ? Color(0xFF33393F)
            : Color(0xFF2A2F33),
        borderRadius: messageType == MessageType.received
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
        crossAxisAlignment: messageType == MessageType.received
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          Text(
            text.trim(),
            softWrap: true,
          ),
          const SizedBox(height: 2),
          Text(
            '${time.hour > 12 ? time.hour - 12 : time.hour}:${time.minute < 10 ? '0' + time.minute.toString() : time.minute} ${time.hour > 12 ? 'PM' : 'AM'}',
            style:
                Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 10.0),
          )
        ],
      ),
    );
  }
}
