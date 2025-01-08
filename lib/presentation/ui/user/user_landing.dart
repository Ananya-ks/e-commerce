import 'package:e_commerce_application/presentation/blocs/cart/user_cart_bloc.dart';
import 'package:e_commerce_application/presentation/ui/user/user_home.dart';
import 'package:e_commerce_application/presentation/ui/user/user_profile.dart';
import 'package:e_commerce_application/presentation/ui/user/user_wishlist.dart';
import 'package:e_commerce_application/routes/app_route_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class UserLandingPage extends StatefulWidget {
  const UserLandingPage({super.key});

  @override
  State<UserLandingPage> createState() => _UserLandingPageState();
}

class _UserLandingPageState extends State<UserLandingPage> {
  int _selectedIndex = 0;
  num totalCheckoutAmt = 0;
  UserCartBloc userCartBloc = UserCartBloc();
  void _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      UserHome(),
      UserWishlist(),
      // UserCart(),
      UserProfile(),
    ];
    return BlocProvider<UserCartBloc>(
      create: (_) => UserCartBloc(),
      child: BlocConsumer<UserCartBloc, UserCartState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              leading: null,
              actions: [
                IconButton(
                    onPressed: () {
                      GoRouter.of(context)
                          .pushNamed(MyAppRouteConstants.userCartDetails);
                      userCartBloc.add(UserCartPageClickedEvent());
                    },
                    icon: const Icon(Icons.shopping_bag))
              ],
            ),
            bottomNavigationBar: Container(
              color: Colors.brown.shade400,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                child: GNav(
                  padding: const EdgeInsets.all(15),
                  backgroundColor: Colors.brown.shade400,
                  color: Colors.white,
                  tabBackgroundColor: Colors.grey,
                  gap: 8,
                  activeColor: Colors.white,
                  tabs: const [
                    GButton(
                      icon: Icons.home,
                      text: 'Home',
                    ),
                    GButton(
                      icon: Icons.favorite,
                      text: 'Wishlist',
                    ),
                    GButton(
                      icon: Icons.person,
                      text: 'Profile',
                    )
                  ],
                  onTabChange: _onTabChange,
                ),
              ),
            ),
            body: IndexedStack(
              index: _selectedIndex,
              children: _pages,
            ),
          );
        },
      ),
    );
  }
}
