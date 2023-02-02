import 'package:flutter/material.dart';

class Section extends StatelessWidget {
  const Section({
    super.key,
    required this.header,
    required this.children,
  });

  final String header;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(header, style: textTheme.titleMedium),
        const Divider(),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }
}
