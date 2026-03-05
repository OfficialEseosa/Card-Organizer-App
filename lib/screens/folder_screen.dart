import "package:flutter/material.dart";
import '../repositories/folder_repository.dart';
import '../repositories/card_repository.dart';
import '../models/folder.dart';
import 'cards_screen.dart';

class FolderScreen extends StatefulWidget {
  const FolderScreen({super.key});

  @override
  State<FolderScreen> createState() => _FolderScreenState();
}

class _FolderScreenState extends State<FolderScreen> {
  final FolderRepository _folderRepository = FolderRepository();
  final CardRepository _cardRepository = CardRepository();
  List<Folder> _folders = [];
  Map<int, int> _cardCounts = {};

  @override
  void initState() {
    super.initState();
    _loadFolders();
  }

  Future<void> _loadFolders() async {
    final folders = await _folderRepository.getAllFolders();
    final Map<int, int> counts = {};

    for (var folder in folders) {
      counts[folder.id!] = await _cardRepository.getCardCountByFolder(folder.id!);
    }

    setState(() {
      _folders = folders;
      _cardCounts = counts;
    });
  }

  Future<void> _deleteFolder(Folder folder) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Folder?'),
        content: Text(
          'Are you sure you want to delete "${folder.folderName}"? '
          'This will also delete all ${_cardCounts[folder.id!]} cards in this folder.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _folderRepository.deleteFolder(folder.id!);
      _loadFolders();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Folder "${folder.folderName}" deleted')),
        );
      }
    }
  }

  String _getSuitImage(String suitName) {
    switch (suitName) {
      case 'Hearts':
        return 'assets/images/hearts.png';
      case 'Diamonds':
        return 'assets/images/diamonds.png';
      case 'Clubs':
        return 'assets/images/clubs.png';
      case 'Spades':
        return 'assets/images/spades.png';
      default:
        return 'assets/images/spades.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Folders"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Folder',
            onPressed: () {
              // TODO: Add folder logic
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit',
            onPressed: () {
              // TODO: Edit folder logic
            },
          ),
        ],
      ),
      body: _folders.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemCount: _folders.length,
              itemBuilder: (context, index) {
                final folder = _folders[index];
                final cardCount = _cardCounts[folder.id!] ?? 0;

                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CardsScreen(folder: folder),
                        ),
                      );
                      _loadFolders(); // Refresh after returning
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          _getSuitImage(folder.folderName),
                          width: 100,
                          height: 100,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          folder.folderName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '$cardCount cards',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}