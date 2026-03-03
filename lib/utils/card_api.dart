class CardApi {
  static const String baseUrl = 'https://deckofcardsapi.com/static/img';

  static const List<String> cardNames = [
    'Ace', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King',
  ];

  static const List<String> suits = ['Hearts', 'Diamonds', 'Clubs', 'Spades'];

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

  static const Map<String, String> _suitCode = {
    'Spades': 'S',
    'Hearts': 'H',
    'Diamonds': 'D',
    'Clubs': 'C',
  };

  static String getCardImageUrl(String cardName, String suit) {
    final value = _valueCode[cardName] ?? cardName[0].toUpperCase();
    final s = _suitCode[suit] ?? suit[0].toUpperCase();
    return '$baseUrl/${value}$s.png';
  }

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
