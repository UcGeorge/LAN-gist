import 'package:flutter/material.dart';
import 'package:lets_talk/data/data.dart';
import 'package:lets_talk/models/client.dart';
import 'package:lets_talk/models/contact.dart';
import 'package:lets_talk/models/current_chat_model.dart';
import 'package:provider/provider.dart';

class SideBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        border: Border(
          right: BorderSide(color: Color(0xFF242A2E), width: 1.5),
        ),
      ),
      height: double.infinity,
      width: 260.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8.0),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.asset(
                  'assets/icon.png',
                  height: 55.0,
                  filterQuality: FilterQuality.high,
                ),
              ),
              const SizedBox(width: 8.0),
              Text(
                "LAN gist",
                style: Theme.of(context)
                    .textTheme
                    .headline2!
                    .copyWith(fontStyle: FontStyle.italic),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 16.0,
            ),
            child: Text(
              'CONTACTS',
              style: Theme.of(context).textTheme.headline4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          _ContactsList(),
        ],
      ),
    );
  }
}

class _ContactsList extends StatefulWidget {
  const _ContactsList({
    Key? key,
  }) : super(key: key);

  @override
  __ContactsListState createState() => __ContactsListState();
}

class __ContactsListState extends State<_ContactsList> {
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
    final List<Contact>? contactList =
        context.watch<ContactListModel>().contactList;

    return Expanded(
      child: Scrollbar(
        controller: _scrollController,
        isAlwaysShown: true,
        child: ListView(
          controller: _scrollController,
          // padding: EdgeInsets.symmetric(vertical: 12.0),
          physics: ClampingScrollPhysics(),
          children: contactList?.map((e) {
                final selected =
                    context.watch<CurrentChatModel>().selected?.name == e.name;
                return context.read<Client>().name == e.name
                    ? SizedBox.shrink()
                    : Container(
                        color:
                            selected ? Color(0xFF9D7D2A) : Colors.transparent,
                        child: ListTile(
                          selected: selected,
                          //selectedTileColor: Color(0xFFF07E20),
                          //hoverColor: Color(0xFF353C43),
                          onTap: () => {
                            if (!selected)
                              context.read<CurrentChatModel>().selectContact(e)
                          },
                          enabled: true,
                          dense: true,
                          title: Text(
                            e.name,
                            style: Theme.of(context).textTheme.bodyText2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            'address: ${e.address}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(fontSize: 10.0),
                            overflow: TextOverflow.ellipsis,
                          ),
                          leading: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: userIconColors[
                                  e.name.length % userIconColors.length],
                            ),
                            child: Center(
                              child: Text(
                                e.name[0],
                                style: Theme.of(context)
                                    .textTheme
                                    .headline2!
                                    .copyWith(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 18.0),
                              ),
                            ),
                          ),
                        ),
                      );
              }).toList() ??
              [],
        ),
      ),
    );
  }
}
