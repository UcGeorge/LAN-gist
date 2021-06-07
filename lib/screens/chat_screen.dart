import 'package:flutter/material.dart';
import 'package:lets_talk/models/current_chat_model.dart';
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

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contact = context.watch<CurrentChatModel>().selected;

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
                    //body: Container(),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 60.0,
                  color: Theme.of(context).primaryColor,
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
                          onSubmitted: (value) {},
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
                          onPressed: () {},
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
