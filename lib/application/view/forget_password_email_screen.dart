import 'package:flutter/material.dart';
import 'package:pocketkeeper/application/controller/forget_password_email_controller.dart';
import 'package:pocketkeeper/template/utils/spacing.dart';
import 'package:pocketkeeper/template/widgets/button/button.dart';
import 'package:pocketkeeper/template/widgets/text/text.dart';
import 'package:pocketkeeper/theme/text_style.dart';
import 'package:pocketkeeper/widget/circular_loading_indicator.dart';
import 'package:pocketkeeper/widget/exception_handler_toast.dart';
import '../../theme/custom_theme.dart';
import '../../template/state_management/state_management.dart';

class ForgetPasswordEmailScreen extends StatefulWidget {
  const ForgetPasswordEmailScreen({super.key});

  @override
  State<ForgetPasswordEmailScreen> createState() {
    return _ForgetPasswordEmailState();
  }
}

class _ForgetPasswordEmailState extends State<ForgetPasswordEmailScreen>
    with TickerProviderStateMixin {
  late CustomTheme customTheme;
  late OutlineInputBorder outlineInputBorder;
  late FPEmailController controller;

  FocusNode emailFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    customTheme = CustomTheme();
    outlineInputBorder = OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(30)),
      borderSide: BorderSide(
        color: customTheme.colorPrimary.withOpacity(0.2),
        width: 2,
      ),
    );

    controller = FxControllerStore.put(FPEmailController(this));
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<FPEmailController>(
      controller: controller,
      builder: (controllers) {
        return _buildBody();
      },
    );
  }

  Widget _buildBody() {
    // Prevent load UI if data is not finish load
    if (!controller.isDataFetched) return buildCircularLoadingIndicator();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.1,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTopSection(),
            FxSpacing.height(10),
            FxText.bodyMedium(
              'Please write your email to reeive a confirmation code to set a new password.',
              fontSize: 18,
              xMuted: true,
            ),
            FxSpacing.height(20),
            _buildEmailField(),
            FxSpacing.height(20),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    return Column(
      children: [
        Image.asset('assets/forget_password.png'),
        FxSpacing.height(20),
        FxText.titleLarge(
          'Forget Password',
          fontWeight: 700,
          fontSize: 28,
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return SlideTransition(
      position: controller.emailAnimation.returnAnimationOffset(),
      child: TextFormField(
        focusNode: emailFocusNode,
        style: FxTextStyle.bodyMedium(),
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          isDense: true,
          filled: true,
          fillColor: customTheme.white,
          hintText: "Email Address",
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorder,
          border: outlineInputBorder,
          prefixIcon: Icon(
            Icons.email,
            color: emailFocusNode.hasFocus
                ? customTheme.colorPrimary
                : customTheme.black,
          ),
          contentPadding: FxSpacing.all(16),
          hintStyle: FxTextStyle.bodyMedium(xMuted: true),
          isCollapsed: true,
        ),
        maxLines: 1,
        controller: controller.emailController,
        validator: controller.validateEmail,
        cursorColor: customTheme.black,
        onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: FxButton.rounded(
        onPressed: () {
          controller.onButtonClick().then((value) {
            Navigator.pop(context);
          }).catchError((error) {
            // Handle any errors here
            ExceptionHandler.handleException(error);
          });
        },
        backgroundColor: customTheme.colorPrimary,
        child: FxText.bodyMedium(
          'PROCEED',
          fontWeight: 700,
          color: customTheme.white,
        ),
      ),
    );
  }
}
