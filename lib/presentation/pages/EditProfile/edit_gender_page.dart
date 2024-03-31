import 'package:flutter/material.dart';
import 'package:instaclone/presentation/pages/EditProfile/edit_profile_page.dart';
import 'package:instaclone/presentation/resources/constants/sizedbox_constants.dart';
import 'package:instaclone/providers/profile_provider.dart';
import 'package:instaclone/utilities/snackbars.dart';
import 'package:provider/provider.dart';

class EditGenderPage extends StatefulWidget {
  static const String routeName = '/edit-gender';
  const EditGenderPage({super.key});

  @override
  State<EditGenderPage> createState() => _EditGenderPageState();
}

class _EditGenderPageState extends State<EditGenderPage> {
  late String receivedValue;
  bool isMale = false;
  bool isFemale = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final routeArgs =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      receivedValue = routeArgs['gender'];
      setState(() {
        if (receivedValue.isEmpty) {
          isMale = false;
          isFemale = false;
        } else if (receivedValue == 'Male') {
          isMale = true;
        } else {
          isFemale = true;
        }
      });
    });
    super.initState();
  }

  String getGender() {
    if (!isFemale && !isMale) {
      return '';
    } else if (isFemale) {
      return 'Female';
    } else {
      return 'Male';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.close,
          ),
        ),
        title: Text(
          'Gender',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        actions: [
          IconButton(
            onPressed: () async {
              Navigator.of(context).popUntil(
                ModalRoute.withName(
                  EditProfilePage.routename,
                ),
              );
              await Provider.of<ProfileProvider>(context, listen: false)
                  .editGender(getGender())
                  .then((value) {
                SnackBars.showNormalSnackbar(
                    context, ('Your gender has been updated.'));
              }).catchError((e) {
                SnackBars.showErrorSnackBar(context, (e.toString()));
              });
            },
            icon: const Icon(
              Icons.check,
              color: Colors.blueAccent,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 15,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This won\'t appear on your public profile.',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            SizedBoxConstants.sizedboxh10,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Male'),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isMale = !isMale;
                      if (isMale) {
                        isFemale = false; // Unselect female if male is selected
                      } else {
                        isFemale = true;
                      }
                    });
                  },
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isMale ? Colors.blue : Colors.grey,
                        width: 2,
                      ),
                    ),
                    child: isMale
                        ? const Center(
                            child: Icon(
                              Icons.check,
                              size: 18,
                              color: Colors.blue,
                            ),
                          )
                        : null,
                  ),
                ),
              ],
            ),
            SizedBoxConstants.sizedboxh10,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Female'),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isFemale = !isFemale;
                      if (isFemale) {
                        isMale = false; // Unselect male if female is selected
                      } else {
                        isMale = true;
                      }
                    });
                  },
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isFemale ? Colors.blue : Colors.grey,
                        width: 2,
                      ),
                    ),
                    child: isFemale
                        ? const Center(
                            child: Icon(
                              Icons.check,
                              size: 18,
                              color: Colors.blue,
                            ),
                          )
                        : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
