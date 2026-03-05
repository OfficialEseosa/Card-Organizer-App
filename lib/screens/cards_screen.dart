import "package:flutter/material.dart";
import '../models/folder.dart';

class CardsScreen extends StatelessWidget {
  final Folder folder;

  const CardsScreen({super.key, required this.folder});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(folder.folderName)),
      body: const Center(),
    );
  }
}