// ignore_for_file: file_names

import 'package:first/Views/Mobile/homeView.dart';
import 'package:flutter/material.dart';

class MobileMain extends StatefulWidget {
  const MobileMain({super.key});

  @override
  State<MobileMain> createState() => _MobileMainState();
}

class _MobileMainState extends State<MobileMain> {
  @override
  Widget build(BuildContext context) {
    return const HomeView();
  }
}
