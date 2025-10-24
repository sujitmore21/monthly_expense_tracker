import 'dart:convert';
import 'package:http/http.dart' as http;

class ExchangeRateService {
  static const String _baseUrl = 'https://api.exchangerate-api.com/v4/latest';
  static const Map<String, String> _currencySymbols = {
    'USD': '\$',
    'EUR': '€',
    'GBP': '£',
    'JPY': '¥',
    'CAD': 'C\$',
    'AUD': 'A\$',
    'CHF': 'CHF',
    'CNY': '¥',
    'INR': '₹',
    'BRL': 'R\$',
    'MXN': 'Mex\$',
    'KRW': '₩',
    'SGD': 'S\$',
    'NZD': 'NZ\$',
    'HKD': 'HK\$',
    'NOK': 'kr',
    'SEK': 'kr',
    'DKK': 'kr',
    'PLN': 'zł',
    'CZK': 'Kč',
    'HUF': 'Ft',
    'RUB': '₽',
    'TRY': '₺',
    'ZAR': 'R',
    'THB': '฿',
    'MYR': 'RM',
    'PHP': '₱',
    'IDR': 'Rp',
    'VND': '₫',
  };

  static const List<String> _supportedCurrencies = [
    'USD',
    'EUR',
    'GBP',
    'JPY',
    'CAD',
    'AUD',
    'CHF',
    'CNY',
    'INR',
    'BRL',
    'MXN',
    'KRW',
    'SGD',
    'NZD',
    'HKD',
    'NOK',
    'SEK',
    'DKK',
    'PLN',
    'CZK',
    'HUF',
    'RUB',
    'TRY',
    'ZAR',
    'THB',
    'MYR',
    'PHP',
    'IDR',
    'VND',
  ];

  /// Get exchange rates for a base currency
  static Future<Map<String, double>> getExchangeRates(
    String baseCurrency,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/$baseCurrency'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Map<String, double>.from(data['rates']);
      } else {
        throw Exception(
          'Failed to fetch exchange rates: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetching exchange rates: $e');
      // Return default rates (1:1) if API fails
      return {baseCurrency: 1.0};
    }
  }

  /// Convert amount from one currency to another
  static Future<double> convertCurrency(
    double amount,
    String fromCurrency,
    String toCurrency,
  ) async {
    if (fromCurrency == toCurrency) return amount;

    try {
      final rates = await getExchangeRates(fromCurrency);
      final rate = rates[toCurrency] ?? 1.0;
      return amount * rate;
    } catch (e) {
      print('Error converting currency: $e');
      return amount; // Return original amount if conversion fails
    }
  }

  /// Get currency symbol
  static String getCurrencySymbol(String currencyCode) {
    return _currencySymbols[currencyCode] ?? currencyCode;
  }

  /// Get list of supported currencies
  static List<String> getSupportedCurrencies() {
    return List.from(_supportedCurrencies);
  }

  /// Format amount with currency symbol
  static String formatAmount(double amount, String currencyCode) {
    final symbol = getCurrencySymbol(currencyCode);
    return '$symbol${amount.toStringAsFixed(2)}';
  }

  /// Get exchange rate between two currencies
  static Future<double> getExchangeRate(
    String fromCurrency,
    String toCurrency,
  ) async {
    if (fromCurrency == toCurrency) return 1.0;

    try {
      final rates = await getExchangeRates(fromCurrency);
      return rates[toCurrency] ?? 1.0;
    } catch (e) {
      print('Error getting exchange rate: $e');
      return 1.0;
    }
  }
}

class CurrencyModel {
  final String code;
  final String name;
  final String symbol;
  final bool isDefault;

  const CurrencyModel({
    required this.code,
    required this.name,
    required this.symbol,
    this.isDefault = false,
  });

  factory CurrencyModel.fromCode(String code) {
    final symbol = ExchangeRateService.getCurrencySymbol(code);
    return CurrencyModel(
      code: code,
      name: _getCurrencyName(code),
      symbol: symbol,
    );
  }

  static String _getCurrencyName(String code) {
    const Map<String, String> currencyNames = {
      'USD': 'US Dollar',
      'EUR': 'Euro',
      'GBP': 'British Pound',
      'JPY': 'Japanese Yen',
      'CAD': 'Canadian Dollar',
      'AUD': 'Australian Dollar',
      'CHF': 'Swiss Franc',
      'CNY': 'Chinese Yuan',
      'INR': 'Indian Rupee',
      'BRL': 'Brazilian Real',
      'MXN': 'Mexican Peso',
      'KRW': 'South Korean Won',
      'SGD': 'Singapore Dollar',
      'NZD': 'New Zealand Dollar',
      'HKD': 'Hong Kong Dollar',
      'NOK': 'Norwegian Krone',
      'SEK': 'Swedish Krona',
      'DKK': 'Danish Krone',
      'PLN': 'Polish Zloty',
      'CZK': 'Czech Koruna',
      'HUF': 'Hungarian Forint',
      'RUB': 'Russian Ruble',
      'TRY': 'Turkish Lira',
      'ZAR': 'South African Rand',
      'THB': 'Thai Baht',
      'MYR': 'Malaysian Ringgit',
      'PHP': 'Philippine Peso',
      'IDR': 'Indonesian Rupiah',
      'VND': 'Vietnamese Dong',
    };
    return currencyNames[code] ?? code;
  }
}
