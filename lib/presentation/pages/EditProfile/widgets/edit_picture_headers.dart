import 'package:flutter/material.dart';
import 'package:instaclone/presentation/pages/EditProfile/edit_profile_page.dart';
import 'package:instaclone/presentation/pages/EditProfile/edit_selected_picture_page.dart';
import 'package:instaclone/providers/profile_provider.dart';
import 'package:instaclone/utilities/snackbars.dart';
import 'package:provider/provider.dart';

class AdjustHeader extends StatelessWidget {
  const AdjustHeader({
    super.key,
    required ValueNotifier filterModeNotifier,
    required this.setDefaultColorFilter,
  }) : _filterModeNotifier = filterModeNotifier;

  final ValueNotifier _filterModeNotifier;
  final Function setDefaultColorFilter;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(
        8.0,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              _filterModeNotifier.value = EditMode.filterMode;
              setDefaultColorFilter();
            },
            icon: const Icon(
              Icons.arrow_back,
            ),
          ),
          const Text('Edit'),
        ],
      ),
    );
  }
}

class FilterHeader extends StatefulWidget {
  final String imagePath;

  const FilterHeader({
    super.key,
    required this.imagePath,
  });

  @override
  State<FilterHeader> createState() => _FilterHeaderState();
}

class _FilterHeaderState extends State<FilterHeader> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          FloatingActionButton.small(
            backgroundColor: const Color.fromARGB(255, 65, 64, 64),
            child: const Icon(
              Icons.clear,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          Padding(
            padding: const EdgeInsets.only(
              right: 5,
            ),
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.blueAccent,
                ),
              ),
              onPressed: () async {
                Navigator.of(context).popUntil(
                  ModalRoute.withName(
                    EditProfilePage.routename,
                  ),
                );
                await Provider.of<ProfileProvider>(context, listen: false)
                    .editProfileImage(widget.imagePath)
                    .then((value) {
                  Toasts.showNormalSnackbar(
                      context, ('Your profile picture has been updated.'));
                }).catchError((e) {
                  Toasts.showErrorSnackBar(context, (e.toString()));
                });
              },
              child: const Text(
                'Next',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
