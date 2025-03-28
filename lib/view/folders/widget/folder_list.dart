// ignore_for_file: unnecessary_cast

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../view_model/controller/folder_controller.dart';
import '../../audio_list/file_list.dart';
import '../../common_widget/soft_control.dart';

class Folders extends StatefulWidget {
  const Folders({super.key});

  @override
  State<Folders> createState() => _FoldersState();
}

class _FoldersState extends State<Folders> {
  final controller = Get.put(FolderController());
  final GlobalKey<AnimatedListState> _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Load folder list
    controller.getList();
    // Delay insertion to allow folderList to update
    Timer(const Duration(milliseconds: 50), () {
      for (int i = 0; i < controller.folderList.length; i++) {
        _insertItemWithDelay(i);
      }
    });
  }

  void _insertItemWithDelay(int index) {
    Timer(Duration(milliseconds: index * 50), () {
      if (_key.currentState != null) {
        _key.currentState!.insertItem(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.folderList.isEmpty) {
        return const Expanded(
          child: Center(
            child: SizedBox(
              height: 15,
              width: 15,
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            ),
          ),
        );
      } else {
        return Expanded(
          child: AnimatedList(
            key: _key,
            initialItemCount: controller.folderList.length,
            itemBuilder: (context, index, animation) {
              // Each item in folderList is a Map<String, dynamic> from metadata
              final folderData = controller.folderList[index] as Map<String, dynamic>;
              // Get the file path from the map
              final String filePath = folderData['path'] as String;
              // Extract a folder or file name from the path
              final String folderName = filePath.split('/').last;

              final slideAnimation = Tween<Offset>(
                begin: index % 2 == 0
                    ? const Offset(-1.0, 0.0)
                    : const Offset(1.0, 0.0),
                end: const Offset(0.0, 0.0),
              ).animate(CurvedAnimation(
                parent: animation,
                curve: const Interval(0.0, 1.0, curve: Curves.easeOut),
              ));

              return SlideTransition(
                position: slideAnimation,
                child: GestureDetector(
                  onTap: () {
                    // Pass the file path to AudioList
                    Get.to(() => AudioList(
                          path: filePath,
                        ));
                  },
                  child: Container(
                    height: 75,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        CircularSoftButton(
                          radius: 25,
                          icon: const Icon(
                            Icons.folder,
                            color: Colors.orangeAccent,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          folderName,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }
    });
  }
}
