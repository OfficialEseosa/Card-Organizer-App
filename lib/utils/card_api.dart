/// Utility class for generating card image URLs from the Deck of Cards API.
/// Base URL: https://deckofcardsapi.com/static/img/{CODE}.png
///
/// Card codes are formatted as: {Value}{Suit}
///   Value: A, 2, 3, 4, 5, 6, 7, 8, 9, 0 (for 10), J, Q, K
///   Suit:  S (Spades), H (Hearts), D (Diamonds), C (Clubs)
///
/// Examples:
///   Ace of Spades   -> AS
///   10 of Hearts    -> 0H
///   Queen of Clubs  -> QC
class CardApi {
  static const String baseUrl = 'https://deckofcardsapi.com/static/img';

  static const List<String> cardNames = [
    'Ace', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King',
  ];

  static const List<String> suits = ['Hearts', 'Diamonds', 'Clubs', 'Spades'];

  /// Maps card name (e.g. "Ace", "10", "Queen") to its API code character.
  static const Map<String, String> _valueCode = {
    'Ace': 'A',
    '2': '2',
    '3': '3',
    '4': '4',
    '5': '5',
    '6': '6',
    '7': '7',
    '8': '8',
    '9': '9',
    '10': '0',
    'Jack': 'J',
    'Queen': 'Q',
    'King': 'K',
  };

  /// Maps suit name to its API code character.
  static const Map<String, String> _suitCode = {
    'Spades': 'S',
    'Hearts': 'H',
    'Diamonds': 'D',
    'Clubs': 'C',
  };

  /// Returns the image URL for a given card name and suit.
  /// e.g. getCardImageUrl('Ace', 'Spades') -> 'https://deckofcardsapi.com/static/img/AS.png'
  static String getCardImageUrl(String cardName, String suit) {
    final value = _valueCode[cardName] ?? cardName[0].toUpperCase();
    final s = _suitCode[suit] ?? suit[0].toUpperCase();
    return '$baseUrl/${value}$s.png';
  }

  /// Returns a list of all 52 cards as maps with name, suit, and imageUrl.
  static List<Map<String, String>> getAllCards() {
    final List<Map<String, String>> cards = [];
    for (final suit in suits) {
      for (final name in cardNames) {
        cards.add({
          'cardName': name,
          'suit': suit,
          'imageUrl': getCardImageUrl(name, suit),
        });
      }
    }
    return cards;
  }
}
