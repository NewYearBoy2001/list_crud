import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:list_crud/src/constants/assets.dart';
import 'package:list_crud/src/constants/colors.dart';

class CustomSliverHeader extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final String title;
  final String subtitle;
  final VoidCallback? onReload;
  final VoidCallback? onBack;
  final bool showBackButton;
  final IconData leadingIcon;
  final String? buttonLabel;
  final bool showAvatar;
  final String backButtonText;

  CustomSliverHeader({
    required this.expandedHeight,
    required this.title,
    required this.subtitle,
    this.onReload,
    this.onBack,
    this.showAvatar = true,
    this.showBackButton = false,
    this.leadingIcon = Icons.person,
    this.buttonLabel = 'Load Data',
    this.backButtonText = 'Back',
  });

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => 90;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.expand,
      children: [
        Container(
          padding: const EdgeInsets.only(top: 36),
          decoration: const BoxDecoration(
            color: AppColors.primaryBlueColor,
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
          ),
        ),
        if (showBackButton)
          Positioned(
            top: 50,
            left: 10,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: onBack ?? () => Navigator.of(context).maybePop(),
                ),
                Text(
                  backButtonText,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.primaryWhiteColor,
                  ),
                ),
              ],
            ),
          ),
        Center(
          child: Opacity(
            opacity: shrinkOffset / expandedHeight,
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryWhiteColor,
              ),
            ),
          ),
        ),
        Positioned(
          top: (expandedHeight / (showAvatar ? 1.7 : 1.3)) - shrinkOffset,
          left: 18,
          right: 18,
          child: Opacity(
            opacity: (1 - shrinkOffset / expandedHeight).clamp(0.0, 1.0),
            child: showAvatar
                ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: CircleAvatar(
                backgroundColor: Colors.grey.shade200,
                radius: 65,
                child: Icon(Icons.person),
              ),
            )
            : Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Container(
                height: 74,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.primaryWhiteColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey.shade200,
                            radius: 24,
                            child: SvgPicture.asset(
                              Assets.USERS_SVG,
                              fit: BoxFit.scaleDown,
                            ),
                          ),

                          const SizedBox(width: 10),
                          Text(
                            subtitle,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryBlackColor,
                            ),
                          ),
                        ],
                      ),
                      if (onReload != null)
                        TextButton.icon(
                          onPressed: onReload,
                          icon: SvgPicture.asset(
                            Assets.ARROWCLOCKWISE_SVG,
                            fit: BoxFit.scaleDown,
                            height: 20,
                            width: 20,
                          ),
                          label: Text(
                            buttonLabel!,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.primaryBlueColor,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
