import 'dart:io';
import 'package:flutter/material.dart';
import 'package:instaclone/services/color_filters.dart';

class Filters extends StatelessWidget {
  const Filters({
    super.key,
    required this.imageNotifier,
    required this.onTap,
  });

  final ValueNotifier imageNotifier;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    final colorFilters = FilterClass().filtersList();
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: colorFilters.length,
      itemBuilder: (context, index) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              colorFilters[index].filterName.toUpperCase(),
              // style: const TextStyle(
              //   color: Colors.white,
              // ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 0.5,
                vertical: 15,
              ),
              child: ColorFiltered(
                colorFilter: ColorFilter.matrix(colorFilters[index].matrix),
                child: InkWell(
                  onTap: () {
                    onTap(colorFilters[index]);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: 5,
                    ),
                    height: 120,
                    width: 100,
                    child: ValueListenableBuilder(
                        valueListenable: imageNotifier,
                        builder: (context, value, child) {
                          return Image.file(
                            File(value),
                            fit: BoxFit.cover,
                          );
                        }),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
