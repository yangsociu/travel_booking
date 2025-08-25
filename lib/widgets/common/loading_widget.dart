import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final bool isLoading;
  final String? error;
  final Widget child;

  const LoadingWidget({
    super.key,
    required this.isLoading,
    this.error,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (error != null) {
      return Center(child: Text('Lỗi: $error'));
    }
    return child;
  }
}
