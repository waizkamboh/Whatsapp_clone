import 'package:flutter/material.dart';
import '../../res/color/app_color.dart';
import '../../res/size_config/size_config.dart';

class CustomButton extends StatefulWidget {
  const CustomButton({
    this.buttonColor = AppColor.tabColor,
    this.textColor = AppColor.blackColor,
    required this.onPress,
    required this.title,
    this.width ,
    this.height ,
    this.loading = false,
    super.key,
    this.textStyle,
    this.borderColor = AppColor.tabColor, this.image,
    this.radius,
  });
  final bool loading;
  final String title;
  final double? height, width;
  final VoidCallback onPress;
  final Color textColor, buttonColor, borderColor;
  final TextStyle? textStyle;
  final Widget? image;
  final BorderRadius? radius;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return InkWell(
      onTap: widget.onPress,
      child: Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
            color: widget.buttonColor,
            borderRadius: widget.radius,
            border: Border.all(
              color: widget.borderColor,
              width: 1,
            )
        ),
        child: widget.loading?
        const Center(child: CircularProgressIndicator(
          color: AppColor.whiteColor,

        )):
        // Center(child: Text(title, style: textStyle)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.image != null) ...[
              // Display the image if provided
              Padding(
                padding: EdgeInsets.only(right: getWidth(8)),
                child: widget.image,
              ),
            ],
            Text(widget.title, style: widget.textStyle),
          ],
        ),

      ),
    );
  }
}
