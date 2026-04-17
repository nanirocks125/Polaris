import 'package:flutter/material.dart';
import 'package:polaris/components/global_drawer.dart';

class ScaffoldGlobalDrawer extends StatelessWidget {
  final Widget child;
  final String title;

  const ScaffoldGlobalDrawer({
    super.key,
    required this.child,
    this.title = 'Polaris',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      drawer: const GlobalDrawer(), // Your global drawer
      body: child, // This is where the specific page content is injected
    );
  }
}
