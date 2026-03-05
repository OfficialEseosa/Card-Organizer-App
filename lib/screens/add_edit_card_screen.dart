import 'package:flutter/material.dart';
import '../models/folder.dart';
import '../models/card.dart';
import '../repositories/card_repository.dart';
import '../utils/card_api.dart';

class AddEditCardScreen extends StatefulWidget {
  final Folder folder;
  final PlayingCard? card;

  const AddEditCardScreen({super.key, required this.folder, this.card});

  @override
  State<AddEditCardScreen> createState() => _AddEditCardScreenState();
}

class _AddEditCardScreenState extends State<AddEditCardScreen> {
  final CardRepository _cardRepository = CardRepository();
  String? _selectedCardName;
  String? _selectedSuit;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    if (widget.card != null) {
      _isEditing = true;
      _selectedCardName = widget.card!.cardName;
      _selectedSuit = widget.card!.suit;
    } else {
      _selectedSuit = widget.folder.folderName;
    }
  }

  Future<void> _saveCard() async {
    if (_selectedCardName == null || _selectedSuit == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a card name and suit')),
      );
      return;
    }

    final imageUrl = CardApi.getCardImageUrl(_selectedCardName!, _selectedSuit!);

    if (_isEditing) {
      final updatedCard = widget.card!.copyWith(
        cardName: _selectedCardName,
        suit: _selectedSuit,
        imageUrl: imageUrl,
      );
      await _cardRepository.updateCard(updatedCard);
    } else {
      final newCard = PlayingCard(
        cardName: _selectedCardName!,
        suit: _selectedSuit!,
        imageUrl: imageUrl,
        folderId: widget.folder.id!,
      );
      await _cardRepository.insertCard(newCard);
    }

    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Card' : 'Add Card'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_selectedCardName != null && _selectedSuit != null)
              Center(
                child: Container(
                  height: 200,
                  width: 140,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      CardApi.getCardImageUrl(_selectedCardName!, _selectedSuit!),
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(child: Icon(Icons.broken_image, size: 40));
                      },
                    ),
                  ),
                ),
              ),
            DropdownButtonFormField<String>(
              value: _selectedCardName,
              decoration: const InputDecoration(
                labelText: 'Card Name',
                border: OutlineInputBorder(),
              ),
              items: CardApi.cardNames.map((name) {
                return DropdownMenuItem(value: name, child: Text(name));
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedCardName = value);
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedSuit,
              decoration: const InputDecoration(
                labelText: 'Suit',
                border: OutlineInputBorder(),
              ),
              items: CardApi.suits.map((suit) {
                return DropdownMenuItem(value: suit, child: Text(suit));
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedSuit = value);
              },
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveCard,
                    child: Text(_isEditing ? 'Save' : 'Add Card'),
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
