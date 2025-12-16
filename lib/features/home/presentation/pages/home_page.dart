import 'dart:async';

import 'package:dakna/core/localization/app_localizations.dart';
import 'package:dakna/features/location/presentation/cubit/location_cubit.dart';
import 'package:dakna/features/location/presentation/cubit/location_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:super_tooltip/super_tooltip.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = SuperTooltipController();
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LocationCubit>().checkSavedLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);

    return BlocListener<LocationCubit, LocationState>(
      listener: (context, state) {
        if (state is LocationNotSelected) {
          _controller.showTooltip();
          showLocationSheet(context);
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              HeaderSection(toolTipController: _controller),
              SizedBox(height: 20.h),
              const CategoriesSection(),
              SizedBox(height: 20.h),
              const WelcomeBanner(),
              SizedBox(height: 30.h),
              const FreeDeliveryBanner(),

              //const SizedBox(height: 10),
              // Shop Cards List
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Header Section with Curved Bottom and Search Bar ---
class HeaderSection extends StatelessWidget {
  final SuperTooltipController toolTipController;
  const HeaderSection({super.key, required this.toolTipController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 165.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipPath(
            clipper: HeaderClipper(),
            child: Container(
              height: 165.h,
              color: Theme.of(context).primaryColor,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 12, 16, 95.h),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: SuperTooltip(
                          controller: toolTipController,
                          minimumOutsideMargin: 16,
                          backgroundColor: Colors.black,
                          content: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "حدد موقع التوصيل غن طريق اختيار موقع مسجل  \nاو اضافة موقع جديد",
                              softWrap: true,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              showLocationSheet(context);
                            },
                            child: Text(
                              'حدد موقع التوصيل ',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            left: 16,
            right: 16,
            top: 85.h,
            child: AnimatedHintTextField(
              hints: const [
                'ابحث عن وجبات خفيفة',
                'ابحث عن بيتزا ',
                'ابحث عن برجر ',
                'ابحث عن مشروبات',
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedHintTextField extends StatefulWidget {
  final List<String> hints;

  const AnimatedHintTextField({super.key, required this.hints});

  @override
  State<AnimatedHintTextField> createState() => _AnimatedHintTextFieldState();
}

class _AnimatedHintTextFieldState extends State<AnimatedHintTextField> {
  late Timer _timer;
  int _hintIndex = 0;
  int _charIndex = 0;
  String _currentHint = '';

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  void _startTyping() {
    _timer = Timer.periodic(const Duration(milliseconds: 120), (timer) {
      final currentText = widget.hints[_hintIndex];

      if (_charIndex < currentText.length) {
        setState(() {
          _charIndex++;
          _currentHint = currentText.substring(0, _charIndex);
        });
      } else {
        Future.delayed(const Duration(seconds: 1), _startDeleting);
        timer.cancel();
      }
    });
  }

  void _startDeleting() {
    _timer = Timer.periodic(const Duration(milliseconds: 80), (timer) {
      if (_charIndex > 0) {
        setState(() {
          _charIndex--;
          _currentHint = _currentHint.substring(0, _charIndex);
        });
      } else {
        timer.cancel();
        _hintIndex = (_hintIndex + 1) % widget.hints.length;
        _startTyping();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: _currentHint,
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

// Clipper for the header's curved bottom
class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0, size.height - 20);

    // كسرة 1
    path.quadraticBezierTo(
      size.width * 0.15,
      size.height - 12,
      size.width * 0.3,
      size.height - 20,
    );

    // كسرة 2
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height - 30,
      size.width * 0.65,
      size.height - 18,
    );

    // كسرة 3
    path.quadraticBezierTo(
      size.width * 0.85,
      size.height - 26,
      size.width,
      size.height - 16,
    );

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// --- Categories Section (Horizontal List) ---
class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});
  static const List<String> categoryImages = [
    "assets/images/Food.png",
    "assets/images/Groceries.png",
    "assets/images/Delivery_Bag.png",
    "assets/images/pharmacy.png",
    "assets/images/person_holding_shopping_bag.png",
  ];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        children: [
          CategoryItem(title: 'المطاعم', icon: categoryImages[0]),
          CategoryItem(title: 'المتاجر', icon: categoryImages[1]),
          CategoryItem(title: 'بقالة', icon: categoryImages[2]),
          CategoryItem(title: 'الصحة والجمال', icon: categoryImages[3]),
          CategoryItem(
            title: 'استلم بنفسك',
            icon: categoryImages[4],
            discount: 'خصم 15%',
          ),
        ],
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String title;
  final String icon;
  final String? discount;

  const CategoryItem({
    super.key,
    required this.title,
    required this.icon,
    this.discount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 70,
                height: 70.h,
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary, // Light orange/beige
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(image: AssetImage(icon)),
                ),
              ),
              if (discount != null)
                Positioned(
                  top: 10,
                  right: -10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      discount!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

// --- Welcome / Login Banner ---
class WelcomeBanner extends StatelessWidget {
  const WelcomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: BoxBorder.all(color: Colors.grey, width: 0.4),
      ),
      child: Row(
        children: [
          // Placeholder for the phone with 't' logo
          Container(
            width: 80.w,
            height: 100.h,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/dakna_word.png"),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'مرحباً!',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'قم بتسجيل الدخول أو إنشاء حساب للحصول على تجربة طلب معدة خصيصاً لك',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      'تسجيل الدخول',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- Free Delivery Banner with Wavy Top ---
class FreeDeliveryBanner extends StatelessWidget {
  const FreeDeliveryBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 25), // Space for the gift icon
          child: ClipPath(
            clipper: WavyTopClipper(),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.white,
                    Colors.white,
                    Colors.white,
                    const Color.fromARGB(255, 240, 235, 235),
                  ],
                ),
              ),
              padding: const EdgeInsets.fromLTRB(16, 40, 16, 20),

              child: Column(
                children: [
                  Text(
                    'طلبك الأول سيتم توصيله مجاناً',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'استمتع بهديتك الترحيبية!',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Gift Icon
        Positioned(
          top: 0,
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/marker_bag.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Clipper for the wavy top edge
class WavyTopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 20);
    var firstControlPoint = Offset(size.width / 4, 0);
    var firstEndPoint = Offset(size.width / 2, 20);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );
    var secondControlPoint = Offset(size.width - (size.width / 4), 40);
    var secondEndPoint = Offset(size.width, 20);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class LocationSelectionSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.my_location),
            title: Text('استخدم موقعي الحالي'),
            onTap: () {
              // get current location
            },
          ),
          Divider(),
          // ...savedAddresses.map((e) => ListTile(
          //       leading: Icon(Icons.location_on),
          //       title: Text(e.name),
          //       subtitle: Text(e.details),
          //       onTap: () {
          //         context.read<LocationCubit>().selectLocation(e);
          //         Navigator.pop(context);
          //       },
          //     )),
          Divider(),
          ListTile(
            leading: Icon(Icons.add_location_alt),
            title: Text('إضافة موقع جديد'),
            onTap: () {
              // open map screen
            },
          ),
        ],
      ),
    );
  }
}

void showLocationSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => LocationSelectionSheet(),
  );
}
