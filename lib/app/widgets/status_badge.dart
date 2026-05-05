import 'package:boost_fundr/export.dart';

class StatusBadge extends StatelessWidget {
  final String text;

  const StatusBadge({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: AppTheme.primary,
          fontSize: 12,
        ),
      ),
    );
  }
}
