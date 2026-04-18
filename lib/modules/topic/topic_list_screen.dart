import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:polaris/modules/topic/topic.dart';
import 'package:polaris/modules/topic/topic_service.dart';

class TopicListScreen extends StatelessWidget {
  const TopicListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topicService = TopicService();

    return Scaffold(
      appBar: AppBar(title: const Text('Topic Library')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateDialog(context, topicService),
        label: const Text('New Topic'),
        icon: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<Topic>>(
        stream: topicService.getTopicsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final topics = snapshot.data ?? [];
          if (topics.isEmpty)
            return const Center(child: Text('No topics added yet.'));

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: topics.length,
            itemBuilder: (context, index) {
              final topic = topics[index];
              return Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.topic_outlined),
                  ),
                  title: Text(
                    topic.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Review: ${topic.nextReviewDate?.toLocal().toString().split(' ')[0]}',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/topic-details', extra: topic),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showCreateDialog(BuildContext context, TopicService service) {
    final titleController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Quick Create Topic'),
        content: TextField(
          controller: titleController,
          decoration: const InputDecoration(
            labelText: 'Topic Title (e.g. Preamble)',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.isNotEmpty) {
                await service.createTopic(
                  Topic(title: titleController.text.trim()),
                );
                if (context.mounted) Navigator.pop(ctx);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
