import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:polaris/modules/topic/topic.dart';
import 'package:polaris/modules/topic/topic_service.dart';

class TopicEditScreen extends StatefulWidget {
  final Topic topic;

  const TopicEditScreen({super.key, required this.topic});

  @override
  State<TopicEditScreen> createState() => _TopicEditScreenState();
}

class _TopicEditScreenState extends State<TopicEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _easeController;
  late TextEditingController _intervalController;
  late DateTime _nextReview;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.topic.title);
    _descController = TextEditingController(text: widget.topic.description);

    // SRS Fields
    _easeController = TextEditingController(
      text: (widget.topic.easeFactor / 100).toString(),
    );
    _intervalController = TextEditingController(
      text: widget.topic.interval.toString(),
    );
    _nextReview = widget.topic.nextReviewDate ?? DateTime.now();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final updatedTopic = Topic(
      id: widget.topic.id,
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      easeFactor: (double.parse(_easeController.text) * 100).toInt(),
      interval: int.parse(_intervalController.text),
      nextReviewDate: _nextReview,
      lastReviewedAt: widget.topic.lastReviewedAt,
    );

    await TopicService().updateTopic(updatedTopic);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Topic'),
        actions: [IconButton(icon: const Icon(Icons.check), onPressed: _save)],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _buildSectionLabel("Basic Information"),
            const SizedBox(height: 12),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Topic Title',
                border: OutlineInputBorder(),
              ),
              validator: (v) => v!.isEmpty ? 'Title is required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descController,
              decoration: const InputDecoration(
                labelText: 'Description / Key Concept',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),

            const SizedBox(height: 32),
            _buildSectionLabel("Spaced Repetition (SRS) Settings"),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _easeController,
                    decoration: const InputDecoration(
                      labelText: 'Ease Factor',
                      border: OutlineInputBorder(),
                      helperText: 'Default: 2.5',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _intervalController,
                    decoration: const InputDecoration(
                      labelText: 'Interval (Days)',
                      border: OutlineInputBorder(),
                      helperText: 'Next session in...',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Next Review Date'),
              subtitle: Text(_nextReview.toLocal().toString().split(' ')[0]),
              trailing: const Icon(Icons.calendar_month),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey.shade700),
                borderRadius: BorderRadius.circular(4),
              ),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _nextReview,
                  firstDate: DateTime.now().subtract(const Duration(days: 30)),
                  lastDate: DateTime.now().add(const Duration(days: 3650)),
                );
                if (picked != null) setState(() => _nextReview = picked);
              },
            ),
            const SizedBox(height: 40),
            OutlinedButton.icon(
              onPressed: () {
                // Quick reset for a topic you want to start over
                setState(() {
                  _easeController.text = "2.5";
                  _intervalController.text = "0";
                  _nextReview = DateTime.now();
                });
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Reset SRS Progress'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.orangeAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label.toUpperCase(),
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.blueGrey,
        letterSpacing: 1.1,
      ),
    );
  }
}
