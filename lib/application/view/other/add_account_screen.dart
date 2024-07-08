import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/app_constant.dart';
import 'package:pocketkeeper/application/controller/other/add_account_controller.dart';
import 'package:pocketkeeper/application/expense_cache.dart';
import 'package:pocketkeeper/application/model/money_account.dart';
import 'package:pocketkeeper/theme/custom_theme.dart';
import 'package:pocketkeeper/widget/appbar.dart';
import 'package:pocketkeeper/widget/circular_loading_indicator.dart';
import 'package:pocketkeeper/widget/show_toast.dart';
import '../../../template/state_management/state_management.dart';

class AddAccountScreen extends StatefulWidget {
  final Accounts? selectedAccount;
  const AddAccountScreen({super.key, this.selectedAccount});

  @override
  State<AddAccountScreen> createState() {
    return _AddAccountScreenState();
  }
}

class _AddAccountScreenState extends State<AddAccountScreen>
    with TickerProviderStateMixin {
  late CustomTheme customTheme;
  late AddAccountController controller;

  late TabController accountTabController;

  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    customTheme = CustomTheme();

    controller =
        FxControllerStore.put(AddAccountController(widget.selectedAccount));
    accountTabController = TabController(
      length: ExpenseCache.accounts.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    accountTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<AddAccountController>(
      controller: controller,
      builder: (controllers) {
        return _buildBody();
      },
    );
  }

  Widget _buildBody() {
    // Prevent load UI if data is not finish load
    if (!controller.isDataFetched) {
      // Display spinner while loading
      return buildCircularLoadingIndicator();
    }

    return GestureDetector(
      onVerticalDragDown: (_) => focusNode.unfocus(),
      child: Scaffold(
        appBar: buildCommonAppBar(
          headerTitle: (controller.selectedAccount == null)
              ? "Add Account"
              : "Edit Account",
          context: context,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: controller.formKey,
                child: TextFormField(
                  focusNode: focusNode,
                  controller: controller.accountNameController,
                  maxLength: 30,
                  decoration: InputDecoration(
                    labelText: "Account Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  validator: controller.validateAccountName,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: iconList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          controller.selectedIconHex =
                              iconList[index].codePoint;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: controller.selectedIconHex ==
                                  iconList[index].codePoint
                              ? customTheme.lightPurple
                              : customTheme.lightBlack.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          IconData(
                            iconList[index].codePoint,
                            fontFamily: 'MaterialIcons',
                          ),
                          color: controller.selectedIconHex ==
                                  iconList[index].codePoint
                              ? customTheme.white
                              : customTheme.black,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            controller.submitAccount().then((value) {
              if (value) {
                showToast(customMessage: "Account saved successfully");
                Navigator.pop(context);
                setState(() {});
              }
            });
          },
          child: const Icon(Icons.check),
        ),
      ),
    );
  }
}
