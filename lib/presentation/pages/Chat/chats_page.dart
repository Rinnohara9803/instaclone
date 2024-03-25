import 'package:firebase_auth/firebase_auth.dart';
import 'package:instaclone/apis/chat_apis.dart';
import 'package:instaclone/apis/user_apis.dart';
import 'package:flutter/material.dart';
import '../../../models/chat_user.dart';
import 'widgets/chat_user_card.dart';

class ChatsPage extends StatefulWidget {
  static const String routename = '/chats-page';
  final Function navigateBack;
  const ChatsPage({
    super.key,
    required this.navigateBack,
  });

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  List<String> userIds = [];
  List<ChatUser> users = [];
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () {
              widget.navigateBack();
            },
          ),
          title: Text(
            user!.email as String,
            style: Theme.of(context).textTheme.bodyMedium!,
          ),
        ),
        body: StreamBuilder(
          stream: UserApis.getAllFollowings(user!.uid),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.none:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.active:
              case ConnectionState.done:
                if (snapshot.hasData) {
                  userIds = [];
                  for (var i in snapshot.data!.docs) {
                    userIds.add(i.data()['userId']);
                  }
                }
                if (userIds.isEmpty) {
                  return const Center(
                    child: Text(
                      'You have no followings',
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: userIds.length,
                    itemBuilder: (context, index) {
                      return StreamBuilder(
                          stream: UserApis.getUser(userIds[index]),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              users = [];
                              users.add(ChatUser.fromJson(snapshot.data!.data()
                                  as Map<String, dynamic>));
                            }
                            if (users.isEmpty) {
                              return const SizedBox();
                            } else {
                              return ChatUserCard(
                                chatUser: users[0],
                              );
                            }
                          });
                    },
                  );
                }
            }
          },
        ),
      ),
    );
  }
}
