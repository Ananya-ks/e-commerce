// import 'package:e_commerce_application/presentation/ui/landing.dart';
import 'package:e_commerce_application/presentation/ui/admin/admin_home.dart';
import 'package:e_commerce_application/presentation/ui/admin/admin_landing.dart';
import 'package:e_commerce_application/presentation/ui/admin/admin_new_product_form.dart';
import 'package:e_commerce_application/presentation/ui/admin/admin_orders.dart';
import 'package:e_commerce_application/presentation/ui/admin/admin_products.dart';
import 'package:e_commerce_application/presentation/ui/admin/admin_profile.dart';
import 'package:e_commerce_application/presentation/ui/login.dart';
import 'package:e_commerce_application/presentation/ui/signup.dart';
import 'package:e_commerce_application/presentation/ui/wrapper.dart';
import 'package:e_commerce_application/routes/app_route_const.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
            return AdminLandinPage();
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
            return AdminProductsPage();
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
            return AdminNewProductForm();
          }),
    ],
  );
}
