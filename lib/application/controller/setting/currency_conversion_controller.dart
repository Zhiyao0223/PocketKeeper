import 'package:currency_converter/currency.dart';
import 'package:currency_converter/currency_converter.dart';
import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/model/currencies.dart';
import 'package:pocketkeeper/template/state_management/controller.dart';
import 'package:pocketkeeper/utils/validators/string_validator.dart';

class CurrencyConversionController extends FxController {
  bool isDataFetched = false;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  int fromCurrencyIndex = 70, toCurrencyIndex = 93;
  double result = 0.0;
  String targetCurrencySymbol = "\$";
  String fromCurrencyCode = "MYR";
  String toCurrencyCode = "IDR";

  List<Map<String, dynamic>> currencyDatabase = [];

  TextEditingController amountController = TextEditingController();

  // Constructor
  CurrencyConversionController();

  @override
  void initState() {
    super.initState();

    currencyDatabase = currencies;

    // Sort
    currencyDatabase.sort((a, b) => a['code'].compareTo(b['code']));

    fetchData();
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  void fetchData() async {
    targetCurrencySymbol = currencyDatabase[toCurrencyIndex]['symbol'];

    isDataFetched = true;
    update();
  }

  void swapCurrency() {
    int tmpIndex = fromCurrencyIndex;
    fromCurrencyIndex = toCurrencyIndex;
    toCurrencyIndex = tmpIndex;

    String tmpCode = fromCurrencyCode;
    fromCurrencyCode = toCurrencyCode;
    toCurrencyCode = tmpCode;

    update();
  }

  void convert() async {
    // Refetch the data
    fromCurrencyCode = currencyDatabase[fromCurrencyIndex]['code'];
    toCurrencyCode = currencyDatabase[toCurrencyIndex]['code'];
    targetCurrencySymbol = currencyDatabase[toCurrencyIndex]['symbol'];

    // Convert to enum
    Currency fromCurrency = Currency.values.firstWhere((element) =>
        element.name.toLowerCase() == fromCurrencyCode.toLowerCase());

    Currency toCurrency = Currency.values.firstWhere((element) =>
        element.name.toLowerCase() == toCurrencyCode.toLowerCase());

    double? tmpResult = await CurrencyConverter.convert(
      from: fromCurrency,
      to: toCurrency,
      amount: double.parse(amountController.text),
      withoutRounding: true,
    );

    if (tmpResult != null) {
      result = tmpResult;
      update();
    }
  }

  void setCurrency(bool isFromCurrency, int index) {
    if (isFromCurrency) {
      fromCurrencyIndex = index;
      fromCurrencyCode = currencyDatabase[index]['code'];
    } else {
      toCurrencyIndex = index;
      toCurrencyCode = currencyDatabase[index]['code'];
    }
    update();
  }

  String? validateAmount(String? value) {
    if (validateEmptyString(value)) {
      return "Amount is required";
    }

    if (double.tryParse(value!) == null) {
      return "Invalid amount";
    }

    return null;
  }

  @override
  String getTag() {
    return "CurrencyConversionController";
  }
}
