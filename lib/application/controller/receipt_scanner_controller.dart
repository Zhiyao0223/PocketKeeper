import 'dart:developer' as dev;
import 'dart:io';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:intl/intl.dart';
import 'package:pocketkeeper/application/model/expense.dart';
import 'package:pocketkeeper/utils/converters/string.dart';
import 'package:pocketkeeper/utils/validators/custom_validator.dart';
import 'package:pocketkeeper/utils/validators/string_validator.dart';
import 'package:pocketkeeper/widget/show_toast.dart';
import '../../template/state_management/controller.dart';

class ProcessedLine {
  final String text;
  final double yPosition;

  ProcessedLine({required this.text, required this.yPosition});
}

class ReceiptScannerController extends FxController {
  bool isDataFetched = false, onSubmit = false;

  String picture = "";
  Expenses? selectedExpenses;

  // Contructor
  ReceiptScannerController();

  @override
  void initState() {
    super.initState();

    // Fetch data
    fetchData();
  }

  void fetchData() async {
    isDataFetched = true;
    update();
  }

  // Scan through camera or upload receipt from gallery
  Future<bool> scanReceipt() async {
    picture = "";
    List<String> tempPics = [];
    try {
      tempPics = await CunningDocumentScanner.getPictures(
            isGalleryImportAllowed: true,
            noOfPages: 1,
          ) ??
          [];
      if (!mounted) return true;

      picture = tempPics[0];
    } catch (exception) {
      // Handle exception here
      dev.log(exception.toString());
    }
    return true;
  }

  // Submit receipt to OCR for processing
  Future<bool> confirmReceipt() async {
    selectedExpenses = Expenses();
    selectedExpenses!.image = File(picture).readAsBytesSync();

    // Convert image to file
    InputImage inputImage = InputImage.fromFile(File(picture));

    // Perform OCR to extract text
    final textRecognizer = TextRecognizer();
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);

    List<String> processedText =
        _processTextRecognitionResult(recognizedText.blocks);

    Map<String, dynamic> receiptInfo = extractReceiptInfo(processedText);

    // Now you can access the extracted information
    DateTime? receiptDateTime = receiptInfo['dateTime'];
    String expensesRemark = receiptInfo['expensesRemark'];
    double totalPrice = receiptInfo['totalPrice'];
    // List<String> items = receiptInfo['items'];

    // Use the extracted information as needed
    dev.log('Date and Time: ${receiptDateTime?.toString() ?? 'Not found'}');
    dev.log('Expenses Remark: $expensesRemark');
    dev.log('Total Price: \$${totalPrice.toStringAsFixed(2)}');
    // dev.log('Items:');
    // for (String item in items) {
    //   dev.log('  $item');
    // }

    if (checkIfExtractUsefulData(
      description: expensesRemark,
      amount: totalPrice.toString(),
      date: receiptDateTime.toString(),
    )) {
      selectedExpenses!.description = expensesRemark;
      selectedExpenses!.amount = totalPrice;
      selectedExpenses!.expensesDate = receiptDateTime ?? DateTime.now();
    } else {
      // Handle invalid data
      dev.log('Invalid data extracted from receipt');
      showToast(customMessage: "Failed to extract data from receipt");
    }

    // Close resource
    textRecognizer.close();

    // Perform OCR
    return true;
  }

  List<String> _processTextRecognitionResult(List<TextBlock> blocks) {
    List<ProcessedLine> processedResults = [];

    // Regroup textblock
    List<TextBlock> groupBlocks = _regroupTextBlocks(blocks);

    for (TextBlock block in groupBlocks) {
      for (TextLine line in block.lines) {
        String processedText = _processLine(line.text);
        if (processedText.isNotEmpty) {
          processedResults.add(ProcessedLine(
            text: processedText,
            yPosition: line.boundingBox.top,
          ));
        }
      }
    }

    // Sort the results based on y-coordinate (top to bottom)
    processedResults.sort((a, b) => a.yPosition.compareTo(b.yPosition));

    return processedResults.map((line) => line.text).toList();
  }

  List<TextBlock> _regroupTextBlocks(List<TextBlock> originalBlocks) {
    List<TextBlock> regroupedBlocks = [];
    double threshold = 5.0;

    if (originalBlocks.isEmpty) return regroupedBlocks;

    // Sort blocks by their top y-coordinate
    originalBlocks
        .sort((a, b) => a.boundingBox.top.compareTo(b.boundingBox.top));

    TextBlock currentBlock = originalBlocks[0];
    List<TextLine> currentLines = List.from(currentBlock.lines);

    for (int i = 1; i < originalBlocks.length; i++) {
      TextBlock block = originalBlocks[i];

      if ((block.boundingBox.top - currentBlock.boundingBox.top).abs() <=
          threshold) {
        // Same line, merge blocks
        currentLines.addAll(block.lines);
        // Sort lines by their left x-coordinate
        currentLines
            .sort((a, b) => a.boundingBox.left.compareTo(b.boundingBox.left));
      } else {
        // New line, create a new block
        regroupedBlocks.add(TextBlock(
          cornerPoints: currentBlock.cornerPoints,
          text: currentLines.map((l) => l.text).join(' '),
          boundingBox: currentBlock.boundingBox,
          recognizedLanguages: currentBlock.recognizedLanguages,
          lines: currentLines,
        ));
        currentBlock = block;
        currentLines = List.from(block.lines);
      }
    }

    // Add the last block
    regroupedBlocks.add(TextBlock(
      cornerPoints: currentBlock.cornerPoints,
      text: currentLines.map((l) => l.text).join(' '),
      boundingBox: currentBlock.boundingBox,
      recognizedLanguages: currentBlock.recognizedLanguages,
      lines: currentLines,
    ));

    return regroupedBlocks;
  }

  String _processLine(String text) {
    // Remove leading/trailing whitespace
    text = text.trim();

    // Regular expressions for different receipt line formats
    RegExp itemWithQuantityAndPrice =
        RegExp(r'^([\w\s]+)\s+(\d+(?:\.\d+)?)\s+\$?(\d+(?:\.\d+)?)$');
    RegExp itemWithPrice = RegExp(r'^([\w\s]+)\s+\$?(\d+(?:\.\d+)?)$');
    RegExp totalLine = RegExp(
        r'(subtotal|total|tax|discount).*?\$?\s*(\d+(?:\.\d+)?)$',
        caseSensitive: false);

    // Date format (e.g. date 12/31/2021)
    RegExp dateLine = RegExp(r'^(date|time)\s*(.+)$', caseSensitive: false);

    // Date format (e.g. 12/31/2021)
    RegExp dateLine2 = RegExp(r'^\d{1,2}/\d{1,2}/\d{2,4}\s*(.+)$');

    // 12 Hour time format (e.g. 1:45 PM)
    RegExp timeLine = RegExp(r'\d{1,2}:\d{2}\s*(AM|PM)');

    // 24 Hour time format (e.g. 13:45)
    RegExp timeLine2 = RegExp(r'\d{1,2}:\d{2}');

    if (itemWithQuantityAndPrice.hasMatch(text)) {
      Match match = itemWithQuantityAndPrice.firstMatch(text)!;
      String productName = match.group(1)!.trim();
      String quantity = match.group(2)!;
      String price = match.group(3)!;
      return 'Item: $productName, Qty: $quantity, Price: $price';
    } else if (itemWithPrice.hasMatch(text)) {
      Match match = itemWithPrice.firstMatch(text)!;
      String productName = match.group(1)!.trim();
      String price = match.group(2)!;
      return 'Item: $productName, Price: $price';
    } else if (totalLine.hasMatch(text)) {
      Match match = totalLine.firstMatch(text)!;
      String type = match.group(1)!.capitalize();
      String amount = match.group(2)!;
      return '$type: $amount';
    } else if (dateLine.hasMatch(text) || dateLine2.hasMatch(text)) {
      Match? match = dateLine.firstMatch(text);
      if (match != null) {
        text = match.group(2)!;
      }

      // Remove time if present
      String value = text.split(' ')[0];
      return 'Date: $value';
    } else if (timeLine.hasMatch(text) || timeLine2.hasMatch(text)) {
      text = text.split(' ')[0]; // Remove date if present
      return 'Time: $text';
    } else if (text.length > 3) {
      // Capture other potentially relevant information
      return 'Info: $text';
    }

    return ''; // Return empty string if the line doesn't match any expected format
  }

  Map<String, dynamic> extractReceiptInfo(List<String> processedLines) {
    DateTime now = DateTime.now();
    DateTime? dateTime;
    String expensesRemark = '';
    double totalPrice = 0, totalTax = 0, totalDiscount = 0;
    List<String> items = [];

    for (String line in processedLines) {
      if (line.startsWith('Date:')) {
        DateTime? tmpDateTime = _parseDateTime(line.substring(5).trim());
        if (tmpDateTime != null) {
          dateTime = DateTime(
            tmpDateTime.year,
            tmpDateTime.month,
            tmpDateTime.day,
            dateTime?.hour ?? now.hour,
            dateTime?.minute ?? now.minute,
            dateTime?.second ?? now.second,
          );
        }
      } else if (line.startsWith('Time:')) {
        DateTime? time = _parseDateTime(line.substring(5).trim(), false);
        if (time != null) {
          dateTime = DateTime(
            dateTime?.year ?? now.year,
            dateTime?.month ?? now.month,
            dateTime?.day ?? now.day,
            time.hour,
            time.minute,
            time.second,
          );
        }
      } else if (line.startsWith('Subtotal:')) {
        totalPrice = double.parse(line.substring(9).trim());
      } else if (line.startsWith('Total:')) {
        totalPrice = double.parse(line.substring(6).trim());
      } else if (line.startsWith('Tax:')) {
        totalTax += double.parse(line.substring(4).trim());
      } else if (line.startsWith('Discount:')) {
        totalDiscount -= double.parse(line.substring(9).trim());
      } else if (line.startsWith('Item:')) {
        items.add(line.substring(5).trim());
      }
    }

    // Take the first item for expenses remark
    if (items.isNotEmpty) {
      expensesRemark = processedLines.firstWhere(
        (line) => line.startsWith('Info:'),
        orElse: () => '',
      );

      if (expensesRemark.isNotEmpty && expensesRemark.length > 5) {
        expensesRemark = expensesRemark.substring(5).trim();
      }
    }

    return {
      'dateTime': dateTime,
      'expensesRemark': expensesRemark,
      'totalPrice': totalPrice,
      'totalTax': totalTax,
      'totalDiscount': totalDiscount,
      'items': items,
    };
  }

  DateTime? _parseDateTime(String dateTimeString, [bool isParseDate = true]) {
    DateTime now = DateTime.now();
    String currentDateTime = now.toString();
    try {
      // Parse time
      if (!isParseDate) {
        String today = currentDateTime.split(' ')[0];
        dateTimeString = '$today $dateTimeString';

        // Check if time is in 12-hour format
        if (dateTimeString.contains('AM') || dateTimeString.contains('PM')) {
          return DateFormat("dd-MM-yyyy hh:mm a").parse(dateTimeString);
        } else {
          return DateFormat("dd-MM-yyyy HH:mm").parse(dateTimeString);
        }
      } else if (dateTimeString.contains('/')) {
        List<String> parts = dateTimeString.split('/');

        // Check if year is in 2-digit format
        if (parts[2].length == 2) {
          int year = int.parse(parts[2]);
          if (year > 50) {
            parts[2] = '19$year';
          } else if (year < 10) {
            parts[2] = '200$year';
          } else {
            parts[2] = '20$year';
          }
        }

        return DateTime(
          int.parse(parts[2]),
          int.parse(parts[1]),
          int.parse(parts[0]),
        );
      }
      return DateTime.parse(dateTimeString);
    } catch (e) {
      // If parsing fails, you might want to try different date formats
      // or return null if you can't parse the date
      dev.log('Failed to parse date: $dateTimeString');
      return null;
    }
  }

  bool checkIfExtractUsefulData({
    required String description,
    required String amount,
    required String date,
  }) {
    bool isUseful = false;

    if (validateEmptyString(description)) {
      isUseful = true;
    } else if (validateDouble(amount)) {
      isUseful = true;
    } else if (validateDateTime(date)) {
      isUseful = true;
    }

    return isUseful;
  }

  @override
  String getTag() {
    return "ReceiptScannerController";
  }
}
