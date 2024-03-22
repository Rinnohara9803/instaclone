import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instaclone/models/chat_user.dart';
import 'package:instaclone/presentation/pages/Search/widgets/search_chat_user_card.dart';
import 'package:instaclone/presentation/resources/themes_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  final Function returnToHomePage;
  const SearchPage({super.key, required this.returnToHomePage});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool _isVisible = true;
  late ScrollController _scrollController;

  List<ChatUser> searchResults = [];

  final _searchController = TextEditingController();

  Future<void> searchUsers(String searchTerm) async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('userName', isGreaterThanOrEqualTo: searchTerm)
        .where('userName', isLessThanOrEqualTo: '$searchTerm\uf8ff')
        .get()
        .then((snapshot) {
      setState(() {
        searchResults = [];
      });
      for (var i in snapshot.docs) {
        setState(() {
          searchResults.add(ChatUser.fromJson(i.data()));
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
    _scrollController = ScrollController();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      setState(() {
        _isVisible = true;
      });
    } else {
      setState(() {
        _isVisible = false;
      });
    }
  }

  Widget searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      child: TextFormField(
        controller: _searchController,
        textAlign: TextAlign.start,
        textAlignVertical: TextAlignVertical.bottom,
        cursorColor: Provider.of<ThemeProvider>(context).isLightTheme
            ? Colors.black
            : Colors.white,
        style: Theme.of(context).textTheme.bodySmall,
        // cursorHeight: 13,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 15,
          ),
          labelStyle: Theme.of(context).textTheme.bodySmall,
          hintText: 'Search...',
          hintStyle: Theme.of(context).textTheme.bodySmall,
          isDense: true,
          prefixIcon: const Icon(
            Icons.search,
            color: Colors.grey,
          ),
          suffixIcon: _searchController.text.isEmpty
              ? null
              : IconButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                  icon: const Icon(
                    Icons.clear,
                    color: Colors.white,
                  ),
                ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              15,
            ),
          ),
          // enabledBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(
          //     15,
          //   ),
          // ),
          // focusedBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(
          //     15,
          //   ),
          // ),
        ),
        onChanged: (value) async {
          await searchUsers(value);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            searchBar(),
            Expanded(
              child: _searchController.text.isEmpty
                  ? const Center(
                      child: Text('Find Users'),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      shrinkWrap: true,
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        if (searchResults.isEmpty) {
                          return const Center(
                            child: Text(
                              'No users found',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          );
                        }
                        return SearchChatUserCard(
                          chatUser: searchResults[index],
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}
