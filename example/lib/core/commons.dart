import 'package:flutter/material.dart';

SliverToBoxAdapter padding({required double height}) =>
    SliverToBoxAdapter(child: SizedBox(height: height));

SliverPadding defaultImage() => SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      sliver: SliverToBoxAdapter(
        child: Image.asset(
          'assets/icons8-azure-48.png',
          package: 'aad_b2c_webview',
          width: 80,
          height: 80,
          fit: BoxFit.contain,
        ),
      ),
    );

SliverPadding buildTitle(String title) => SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      sliver: SliverToBoxAdapter(
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
