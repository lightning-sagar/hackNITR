import 'dart:math';

/// Service providing agricultural, livestock, and farming facts
class AgriculturalFactsService {
  static final AgriculturalFactsService _instance =
      AgriculturalFactsService._internal();

  factory AgriculturalFactsService() => _instance;

  AgriculturalFactsService._internal();

  final Random _random = Random();

  /// Get a random fact from any category
  String getRandomFact() {
    final allFacts = [
      ...livestockFacts,
      ...dairyFacts,
      ...poultryFacts,
      ...farmingTips,
      ...animalHealthFacts,
    ];
    return allFacts[_random.nextInt(allFacts.length)];
  }

  /// Get a random livestock fact
  String getRandomLivestockFact() {
    return livestockFacts[_random.nextInt(livestockFacts.length)];
  }

  /// Get a random dairy fact
  String getRandomDairyFact() {
    return dairyFacts[_random.nextInt(dairyFacts.length)];
  }

  /// Get a random poultry fact
  String getRandomPoultryFact() {
    return poultryFacts[_random.nextInt(poultryFacts.length)];
  }

  /// Get a random farming tip
  String getRandomFarmingTip() {
    return farmingTips[_random.nextInt(farmingTips.length)];
  }

  /// Get a random animal health fact
  String getRandomHealthFact() {
    return animalHealthFacts[_random.nextInt(animalHealthFacts.length)];
  }

  /// Livestock care and management facts
  static const List<String> livestockFacts = [
    'Cows drink up to 70 liters of water per day in hot weather.',
    'Regular movement improves digestion and milk yield in cattle.',
    'Goats can remember and recognize their human caregivers.',
    'Sheep can recognize up to 50 different sheep faces.',
    'Buffalo milk contains 58% more calcium than cow milk.',
    'Cattle have a 330-degree panoramic view around them.',
    'A healthy cow produces about 25-30 liters of milk daily.',
    'Goats are natural browsers and prefer eating leaves over grass.',
    'Proper ventilation reduces livestock diseases by up to 40%.',
    'Livestock stress can reduce productivity by 15-20%.',
  ];

  /// Dairy farming insights
  static const List<String> dairyFacts = [
    'Fresh water access increases milk production by 5-10%.',
    'The first milk after birth, colostrum, boosts calf immunity.',
    'Dairy cows need 12-14 hours of rest daily for optimal yield.',
    'Clean milking equipment prevents mastitis in 80% of cases.',
    'Balanced feed can increase milk fat content by 0.3-0.5%.',
    'Regular grooming reduces stress and improves milk quality.',
    'Cows produce more milk when listening to calming music.',
    'Proper cooling after milking extends milk freshness by 2 days.',
    'Vitamin and mineral supplements improve milk composition.',
    'Dry period management impacts next lactation cycle quality.',
  ];

  /// Poultry farming knowledge
  static const List<String> poultryFacts = [
    'Chickens need 14-16 hours of light for optimal egg production.',
    'Fresh water boosts egg production by up to 20%.',
    'Clean coops reduce respiratory diseases by 60%.',
    'Proper ventilation prevents 70% of poultry health issues.',
    'Layer hens need calcium-rich feed for strong eggshells.',
    'Chickens can recognize over 100 different faces.',
    'Stress-free environments increase egg size and quality.',
    'Broilers need protein-rich diets for healthy weight gain.',
    'Natural light improves chicken immune system health.',
    'Regular cleaning prevents 80% of common poultry diseases.',
  ];

  /// Seasonal farming tips and best practices
  static const List<String> farmingTips = [
    'Soil testing before planting increases crop yield by 20%.',
    'Crop rotation prevents soil nutrient depletion naturally.',
    'Early morning irrigation reduces water loss by 30%.',
    'Organic mulching retains soil moisture for 3-5 days longer.',
    'Integrated pest management reduces chemical use by 50%.',
    'Monsoon preparation protects crops from 60% of rain damage.',
    'Winter fodder storage ensures livestock nutrition year-round.',
    'Compost enriches soil and reduces fertilizer costs by 40%.',
    'Drip irrigation saves 40-60% more water than flooding.',
    'Mixed farming diversifies income and reduces risk.',
  ];

  /// Animal health and disease prevention
  static const List<String> animalHealthFacts = [
    'Early disease detection reduces livestock loss by over 40%.',
    'Vaccinations prevent 90% of common livestock diseases.',
    'Regular deworming improves animal weight gain by 15%.',
    'Clean drinking water prevents 50% of livestock illnesses.',
    'Biosecurity measures reduce disease spread by 70%.',
    'Foot health checks prevent lameness in 80% of cases.',
    'Proper nutrition strengthens animal immune systems naturally.',
    'Quarantine new animals for 21 days to prevent disease spread.',
    'Hoof trimming every 6 months improves cattle mobility.',
    'Early calf care reduces mortality rates by 30%.',
  ];

  /// Connectivity tips for rural farmers
  static const List<String> connectivityTips = [
    'Switch to mobile data if Wi-Fi is unstable.',
    'Try moving to an open area for better signal reception.',
    'Check if airplane mode is accidentally turned on.',
    'Restart your device to refresh network connections.',
    'Contact your network provider if issues persist.',
    'Save important data when connection is available.',
    'Use offline features when network is unavailable.',
  ];

  /// Get a random connectivity tip
  String getRandomConnectivityTip() {
    return connectivityTips[_random.nextInt(connectivityTips.length)];
  }

  /// Get multiple random facts
  List<String> getRandomFacts(int count) {
    final allFacts = [
      ...livestockFacts,
      ...dairyFacts,
      ...poultryFacts,
      ...farmingTips,
      ...animalHealthFacts,
    ];

    if (count >= allFacts.length) {
      return List<String>.from(allFacts)..shuffle(_random);
    }

    final shuffled = List<String>.from(allFacts)..shuffle(_random);
    return shuffled.take(count).toList();
  }

  /// Get facts by category
  List<String> getFactsByCategory(String category) {
    switch (category.toLowerCase()) {
      case 'livestock':
        return livestockFacts;
      case 'dairy':
        return dairyFacts;
      case 'poultry':
        return poultryFacts;
      case 'farming':
        return farmingTips;
      case 'health':
        return animalHealthFacts;
      default:
        return [];
    }
  }
}
