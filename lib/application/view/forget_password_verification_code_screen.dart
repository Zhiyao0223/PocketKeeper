import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/app_constant.dart';
import 'package:pocketkeeper/application/controller/forget_password_verification_code.dart';
import 'package:pocketkeeper/application/view/forget_password_new_password_screen.dart';
import 'package:pocketkeeper/template/utils/spacing.dart';
import 'package:pocketkeeper/template/widgets/button/button.dart';
import 'package:pocketkeeper/template/widgets/text/text.dart';
import 'package:pocketkeeper/template/widgets/text_field/text_field.dart';
import 'package:pocketkeeper/widget/exception_handler_toast.dart';
import '../../theme/custom_theme.dart';
import '../../template/state_management/state_management.dart';

class ForgetPasswordVerificationCodeScreen extends StatefulWidget {
  final String email;
  final int initialVerificationCode;

  const ForgetPasswordVerificationCodeScreen(
      {super.key, required this.email, required this.initialVerificationCode});

  @override
  State<ForgetPasswordVerificationCodeScreen> createState() {
    return _ForgetPasswordVerificationCodeState();
  }
}

class _ForgetPasswordVerificationCodeState
    extends State<ForgetPasswordVerificationCodeScreen>
    with TickerProviderStateMixin {
  late CustomTheme customTheme;
  late FPVerificationCodeController controller;

  @override
  void initState() {
    super.initState();
    customTheme = CustomTheme();

    controller = FxControllerStore.put(FPVerificationCodeController(
      ticker: this,
      inputEmail: widget.email,
      verificationCode: widget.initialVerificationCode,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<FPVerificationCodeController>(
      controller: controller,
      builder: (controllers) {
        return _buildBody();
      },
    );
  }

  Widget _buildBody() {
    if (!controller.isDataFetched) return const CircularProgressIndicator();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GestureDetector(
        onVerticalDragDown: (_) =>
            FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: FxSpacing.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.1,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildTopSection(),
              FxSpacing.height(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Form(
                    key: controller.formKey,
                    child: Column(
                      children: [
                        _buildVerificationCodeBox(0),
                        _buildVerificationCodeBox(1),
                        _buildVerificationCodeBox(2),
                        _buildVerificationCodeBox(3),
                      ],
                    ),
                  ),
                ],
              ),
              FxSpacing.height(20),
              if (controller.hasError)
                // ignore: deprecated_member_use_from_same_package
                FxText.caption(
                  'Invalid verification code',
                  color: customTheme.colorError,
                ),
              FxSpacing.height(30),
              _buildSubmitButton(),
              FxSpacing.height(10),
              InkWell(
                onTap: () {},
                child: FxText.bodyMedium(
                  'Resend',
                  color: customTheme.colorPrimary,
                  fontWeight: 700,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    return Column(
      children: [
        Image.asset(
          forgetPasswordImage,
          width: MediaQuery.of(context).size.width * 0.7,
        ),
        FxSpacing.height(20),
        FxText.titleLarge(
          'Verify email address',
          fontWeight: 700,
          fontSize: 28,
        ),
        FxSpacing.height(10),
        FxText.bodyMedium(
          'Verification code sent to ${controller.inputEmail}',
          textAlign: TextAlign.center,
          fontSize: 18,
          xMuted: true,
        ),
      ],
    );
  }

  Widget _buildVerificationCodeBox(int numberIndex) {
    TextEditingController tmpController = TextEditingController();
    switch (numberIndex) {
      case 0:
        tmpController = controller.firstCodeController;
        break;
      case 1:
        tmpController = controller.secondCodeController;
        break;
      case 2:
        tmpController = controller.thirdCodeController;
        break;
      case 3:
        tmpController = controller.fourthCodeController;
        break;
    }

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: customTheme.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: customTheme.colorPrimary.withOpacity(0.5),
          width: 2,
        ),
      ),
      child: Center(
        child: FxTextField(
            controller: tmpController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.all(0),
              counterText: "",
            ),
            onChanged: (value) {
              // Move pointer to next code textfield
              if (value.isNotEmpty) {
                if (numberIndex < 3) {
                  FocusScope.of(context).nextFocus();
                }
              } else {
                if (numberIndex > 0) {
                  FocusScope.of(context).previousFocus();
                }
              }
            }),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: FxButton.rounded(
        onPressed: () {
          controller.onButtonClick().then((successSendCode) {
            // Only go to code screen if success
            if (successSendCode) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) {
                    return const ForgetPasswordNewPasswordScreen();
                  },
                ),
              );
            } else {
              setState(() {});
            }
          }).catchError((error) {
            // Handle any errors here
            ExceptionHandler.handleException(error);
          });
        },
        backgroundColor: customTheme.colorPrimary,
        child: FxText.bodyMedium(
          'CONFIRM CODE',
          fontWeight: 700,
          color: customTheme.white,
        ),
      ),
    );
  }
}
