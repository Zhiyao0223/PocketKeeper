import 'dart:developer';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:pocketkeeper/application/model/expense.dart';
import '../../template/state_management/controller.dart';

class ReceiptScannerController extends FxController {
  bool isDataFetched = false;

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
      log(exception.toString());
    }
    return true;
  }

  Future<bool> confirmReceipt() async {
    // Expenses tempExpenses = Expenses();

    // Perform OCR
    return true;
  }

  @override
  String getTag() {
    return "ReceiptScannerController";
  }
}
