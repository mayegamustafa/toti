import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_ecommerce/config/app_color.dart';
import 'package:ready_ecommerce/config/theme.dart';
import 'package:ready_ecommerce/controllers/misc/misc_controller.dart';
import 'package:ready_ecommerce/models/eCommerce/product/product_details.dart';
import 'package:ready_ecommerce/views/eCommerce/products/components/iframe_card.dart';
import 'package:ready_ecommerce/views/eCommerce/products/components/video_player.dart';

import '../../../../config/app_constants.dart';

class ProductImagePageView extends ConsumerStatefulWidget {
  final ProductDetails productDetails;
  const ProductImagePageView({
    super.key,
    required this.productDetails,
  });

  @override
  ConsumerState<ProductImagePageView> createState() =>
      _ProductImagePageViewState();
}

class _ProductImagePageViewState extends ConsumerState<ProductImagePageView> {
  PageController pageController = PageController();
  @override
  void initState() {
    // ignore: unused_result
    ref.refresh(currentPageController);
    pageController.addListener(() {
      int? newPage = pageController.page?.round();
      if (newPage != ref.read(currentPageController)) {
        setState(() {
          ref.read(currentPageController.notifier).state = newPage!;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 420.h,
          child: PageView.builder(
            controller: pageController,
            itemCount: widget.productDetails.product.thumbnails.length,
            itemBuilder: (context, index) {
              final fileSystem =
                  widget.productDetails.product.thumbnails[index].type;
              if (fileSystem == FileSystem.image.name) {
                return CachedNetworkImage(
                  imageUrl: widget
                          .productDetails.product.thumbnails[index].thumbnail ??
                      '',
                  fit: BoxFit.contain,
                );
              } else if (fileSystem == FileSystem.file.name) {
                return VideoPlayer(
                  videoUrl:
                      // 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'
                      widget.productDetails.product.thumbnails[index].url ?? '',
                );
              } else {
                return Container(
                  padding: EdgeInsets.only(top: 100.h),
                  width: double.infinity,
                  child: IframeCard(
                    iframeUrl:
                        widget.productDetails.product.thumbnails[index].url ??
                            '',
                  ),
                );
              }
              return null;
            },
          ),
        ),
        Positioned(
          bottom: 16.h,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 3.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: EcommerceAppColor.lightGray,
            ),
            child: Wrap(
              alignment: WrapAlignment.center,
              children: List.generate(
                widget.productDetails.product.thumbnails.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color:
                        ref.read(currentPageController.notifier).state == index
                            ? colors(context).light
                            : colors(context).accentColor!.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(30.sp),
                  ),
                  height: 8.h,
                  width: 8.w,
                ),
              ).toList(),
            ),
          ),
        )
      ],
    );
  }
}
