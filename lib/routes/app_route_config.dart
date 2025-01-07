import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_application/data/models/admin_product_model.dart';
import 'package:e_commerce_application/presentation/ui/admin/admin_edit_product.dart';
import 'package:e_commerce_application/presentation/ui/admin/admin_home.dart';
import 'package:e_commerce_application/presentation/ui/admin/admin_landing.dart';
import 'package:e_commerce_application/presentation/ui/admin/admin_new_product_form.dart';
import 'package:e_commerce_application/presentation/ui/admin/admin_orders.dart';
import 'package:e_commerce_application/presentation/ui/admin/admin_products.dart';
import 'package:e_commerce_application/presentation/ui/admin/admin_profile.dart';
import 'package:e_commerce_application/presentation/ui/login.dart';
import 'package:e_commerce_application/presentation/ui/signup.dart';
import 'package:e_commerce_application/presentation/ui/user/user_landing.dart';
import 'package:e_commerce_application/presentation/ui/user/user_product_details_page.dart';
import 'package:e_commerce_application/presentation/ui/wrapper.dart';
import 'package:e_commerce_application/routes/app_route_const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../presentation/blocs/admin_product/admin_product_form_bloc.dart';

class MyAppRouter {
  static GoRouter router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: <RouteBase>[
      GoRoute(
          path: '/',
          name: MyAppRouteConstants.wrapperRoute,
          builder: (BuildContext context, GoRouterState state) {
            return Wrapper();
          }),
      GoRoute(
          path: '/login',
          name: MyAppRouteConstants.loginRoute,
          builder: (BuildContext context, GoRouterState state) {
            final isAdmin = state.extra as bool? ?? false;
            print('admin / not ${isAdmin}');
            return Login(isAdmin: isAdmin);
          }),
      GoRoute(
          path: '/signup',
          name: MyAppRouteConstants.signupRoute,
          builder: (BuildContext context, GoRouterState state) {
            return SignUp();
          }),
      GoRoute(
          path: '/adminLanding',
          name: MyAppRouteConstants.adminLandingPage,
          builder: (BuildContext context, GoRouterState state) {
            final adminProductFormBloc = state.extra as AdminProductFormBloc?;
            if (adminProductFormBloc == null) {
              throw Exception(
                  'AdminProductFormBloc is required for this route');
            }
            return BlocProvider<AdminProductFormBloc>.value(
              value: adminProductFormBloc,
              child: AdminLandinPage(
                adminProductFormBloc: adminProductFormBloc,
              ),
            );
          }),
      GoRoute(
          path: '/adminHome',
          name: MyAppRouteConstants.adminHomePage,
          builder: (BuildContext context, GoRouterState state) {
            return AdminHomePage();
          }),
      GoRoute(
          path: '/adminOrders',
          name: MyAppRouteConstants.adminOrdersPage,
          builder: (BuildContext context, GoRouterState state) {
            return AdminOrdersPage();
          }),
      GoRoute(
          path: '/adminProducts',
          name: MyAppRouteConstants.adminProductsPage,
          builder: (BuildContext context, GoRouterState state) {
            return AdminProductsPage(
              adminEmail: '',
            );
          }),
      GoRoute(
          path: '/adminProfile',
          name: MyAppRouteConstants.adminProfilePage,
          builder: (BuildContext context, GoRouterState state) {
            return AdminProfilePage();
          }),
      GoRoute(
          path: '/adminProductForm',
          name: MyAppRouteConstants.adminNewProductForm,
          builder: (BuildContext context, GoRouterState state) {
            final adminProductFormBloc = state.extra as AdminProductFormBloc?;
            if (adminProductFormBloc == null) {
              throw Exception(
                  'AdminProductFormBloc is required for this route');
            }
            final adminForm = state.extra as AdminProductFormBloc?;
            final adminEmail = adminForm?.adminEmail;
            return BlocProvider<AdminProductFormBloc>.value(
              value: adminProductFormBloc,
              child: AdminNewProductForm(
                adminEmail: adminEmail,
              ),
            );
          }),
      GoRoute(
        path: '/adminEditProductForm',
        name: MyAppRouteConstants.adminEditProductForm,
        builder: (BuildContext context, GoRouterState state) {
          final extra = state.extra as Map<String, dynamic>?;
          if (extra == null) {
            throw Exception('Extra parameters are required for this route.');
          }
          final adminProductModel =
              extra['adminProductModel'] as AdminProdcutModel?;
          final newProductImages =
              extra['newProductImages'] as List<dynamic>? ?? [];
          final user = FirebaseAuth.instance.currentUser;
          final adminemail = user?.email;
          print('Extra parameters: $extra');

          if (adminProductModel == null) {
            throw Exception('Product details are missing or incomplete.');
          }
          return BlocProvider(
            create: (_) => AdminProductFormBloc(
              firestore: FirebaseFirestore.instance,
              adminEmail: adminemail ?? '',
            ),
            child: AdminEditProduct(
              adminProdcutModel: adminProductModel,
              newProductImages: List<String>.from(newProductImages),
            ),
          );
        },
      ),
      GoRoute(
          path: '/userProdDetails',
          name: MyAppRouteConstants.userProdDetails,
          builder: (BuildContext context, GoRouterState state) {
            final product = state.extra as Map<String, dynamic>;
            return UserProductDetailsPage(product: product);
          }),
      GoRoute(
          path: '/userlandingPage',
          name: MyAppRouteConstants.userLandingPage,
          builder: (BuildContext context, GoRouterState state) {
            return UserLandingPage();
          })
    ],
  );
}
