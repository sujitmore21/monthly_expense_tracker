import 'package:flutter/material.dart';
import '../../core/services/exchange_rate_service.dart';

class CurrencySelector extends StatefulWidget {
  final String selectedCurrency;
  final ValueChanged<String> onCurrencyChanged;
  final bool showAllCurrencies;

  const CurrencySelector({
    super.key,
    required this.selectedCurrency,
    required this.onCurrencyChanged,
    this.showAllCurrencies = false,
  });

  @override
  State<CurrencySelector> createState() => _CurrencySelectorState();
}

class _CurrencySelectorState extends State<CurrencySelector> {
  late String _selectedCurrency;
  List<CurrencyModel> _currencies = [];

  @override
  void initState() {
    super.initState();
    _selectedCurrency = widget.selectedCurrency;
    _loadCurrencies();
  }

  void _loadCurrencies() {
    final supportedCurrencies = ExchangeRateService.getSupportedCurrencies();
    _currencies = supportedCurrencies
        .map((code) => CurrencyModel.fromCode(code))
        .toList();

    // Sort currencies with USD first, then alphabetically
    _currencies.sort((a, b) {
      if (a.code == 'USD') return -1;
      if (b.code == 'USD') return 1;
      return a.name.compareTo(b.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: _selectedCurrency,
      decoration: InputDecoration(
        labelText: 'Currency',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        prefixIcon: const Icon(Icons.attach_money),
      ),
      items: _currencies.map((currency) {
        return DropdownMenuItem<String>(
          value: currency.code,
          child: Row(
            children: [
              Text(
                currency.symbol,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              Text(currency.code),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  currency.name,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            _selectedCurrency = newValue;
          });
          widget.onCurrencyChanged(newValue);
        }
      },
    );
  }
}

class CurrencyDisplayWidget extends StatelessWidget {
  final double amount;
  final String currency;
  final TextStyle? style;

  const CurrencyDisplayWidget({
    super.key,
    required this.amount,
    required this.currency,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final symbol = ExchangeRateService.getCurrencySymbol(currency);
    final formattedAmount = ExchangeRateService.formatAmount(amount, currency);

    return Text(
      formattedAmount,
      style: style ?? Theme.of(context).textTheme.bodyMedium,
    );
  }
}

class CurrencyConverterWidget extends StatefulWidget {
  final double amount;
  final String fromCurrency;
  final String toCurrency;
  final ValueChanged<double>? onAmountChanged;

  const CurrencyConverterWidget({
    super.key,
    required this.amount,
    required this.fromCurrency,
    required this.toCurrency,
    this.onAmountChanged,
  });

  @override
  State<CurrencyConverterWidget> createState() =>
      _CurrencyConverterWidgetState();
}

class _CurrencyConverterWidgetState extends State<CurrencyConverterWidget> {
  double _convertedAmount = 0.0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _convertCurrency();
  }

  @override
  void didUpdateWidget(CurrencyConverterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.amount != widget.amount ||
        oldWidget.fromCurrency != widget.fromCurrency ||
        oldWidget.toCurrency != widget.toCurrency) {
      _convertCurrency();
    }
  }

  Future<void> _convertCurrency() async {
    if (widget.fromCurrency == widget.toCurrency) {
      setState(() {
        _convertedAmount = widget.amount;
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final convertedAmount = await ExchangeRateService.convertCurrency(
        widget.amount,
        widget.fromCurrency,
        widget.toCurrency,
      );

      setState(() {
        _convertedAmount = convertedAmount;
        _isLoading = false;
      });

      widget.onAmountChanged?.call(convertedAmount);
    } catch (e) {
      setState(() {
        _convertedAmount = widget.amount;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Currency Conversion',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'From',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        ExchangeRateService.formatAmount(
                          widget.amount,
                          widget.fromCurrency,
                        ),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'To',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              ExchangeRateService.formatAmount(
                                _convertedAmount,
                                widget.toCurrency,
                              ),
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                            ),
                    ],
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
