import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:polaris/modules/topic/topic.dart';
import 'package:polaris/modules/topic/topic_service.dart';

class TopicDetailsScreen extends StatelessWidget {
  final Topic topic;
  const TopicDetailsScreen({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Topic Overview'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => context.push('/edit-topic', extra: topic),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            topic.title,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildSrsInfo(context),
          const Divider(height: 48),
          const Text(
            'DESCRIPTION',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            topic.description.isEmpty
                ? 'No detailed description.'
                : topic.description,
          ),
        ],
      ),
    );
  }

  Widget _buildSrsInfo(BuildContext context) {
    return Row(
      children: [
        _infoCard("Ease Factor", "${topic.easeFactor / 100}"),
        const SizedBox(width: 12),
        _infoCard("Interval", "${topic.interval} days"),
      ],
    );
  }

  Widget _infoCard(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Topic?'),
        content: const Text(
          'This will permanently delete this topic and all its associated study progress.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await TopicService().deleteTopic(topic.id);
              if (context.mounted) {
                Navigator.pop(ctx);
                context.pop();
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
