import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:polaris/modules/module/module.dart';
import 'package:polaris/modules/module/module_service.dart';
import 'package:polaris/modules/module/module_snapshot.dart';
import 'package:polaris/modules/subject/model/subject.dart';
import 'package:polaris/modules/subject/subject_service.dart';

class SubjectEditScreen extends StatefulWidget {
  final Subject subject;
  const SubjectEditScreen({super.key, required this.subject});

  @override
  State<SubjectEditScreen> createState() => _SubjectEditScreenState();
}

class _SubjectEditScreenState extends State<SubjectEditScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descController;

  // 1. Add a local list to track UI changes
  late List<ModuleSnapshot> _currentModules;

  final ModuleService _moduleService = ModuleService();
  final SubjectService _subjectService = SubjectService();
  late bool _isGS;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.subject.title);
    _descController = TextEditingController(text: widget.subject.description);
    _isGS = widget.subject.isGeneralStudies;

    // 2. Initialize the local list from the existing subject modules
    _currentModules = List.from(widget.subject.modules);
  }

  void _showModulePicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => _ModuleSearchPicker(
        alreadyLinked: _currentModules, // <--- Pass the local list
        onModuleSelected: (module) async {
          await _subjectService.linkModuleToSubject(widget.subject, module);
          setState(() {
            _currentModules.add(module.snapshot);
          });
        },
        onCreateNew: (title) async {
          await _subjectService.createAndLinkModule(widget.subject, title);
          setState(() {
            _currentModules.add(ModuleSnapshot(id: 'temp', title: title));
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Subject'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () async {
              final updated = Subject(
                id: widget.subject.id,
                title: _titleController.text.trim(),
                description: _descController.text.trim(),
                isGeneralStudies: _isGS,
                iconName: widget.subject.iconName,
                // 4. Save the current state of modules
                modules: _currentModules,
                modulesCount: _currentModules.length,
              );
              await SubjectService().updateSubject(updated);
              if (mounted) context.pop();
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // ... (Title and Description TextFields remain same) ...
          const SizedBox(height: 32),
          _buildModuleHeader(),
          const Divider(),

          // 5. Use the local _currentModules list here
          if (_currentModules.isEmpty)
            _buildEmptyModulesPlaceholder()
          else
            ..._currentModules.map(
              (m) => ListTile(
                leading: const Icon(
                  Icons.inventory_2_outlined,
                  color: Colors.blue,
                ),
                title: Text(
                  m.title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                trailing: const Icon(Icons.link, size: 16, color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildModuleHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "MODULES",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            letterSpacing: 1.2,
          ),
        ),
        TextButton.icon(
          onPressed: _showModulePicker,
          icon: const Icon(Icons.add_link_rounded, size: 18),
          label: const Text("Link Module"),
        ),
      ],
    );
  }

  Widget _buildEmptyModulesPlaceholder() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Text(
        "No modules linked yet. Linking modules helps in structured tracking.",
        style: TextStyle(
          color: Colors.grey.shade500,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}

class _ModuleSearchPicker extends StatefulWidget {
  final List<ModuleSnapshot> alreadyLinked; // <--- Add this
  final Function(Module) onModuleSelected;
  final Function(String) onCreateNew;

  const _ModuleSearchPicker({
    required this.alreadyLinked, // <--- Add this
    required this.onModuleSelected,
    required this.onCreateNew,
  });

  @override
  State<_ModuleSearchPicker> createState() => _ModuleSearchPickerState();
}

class _ModuleSearchPickerState extends State<_ModuleSearchPicker> {
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              hintText: "Search or create module...",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (val) => setState(() => _searchQuery = val),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: StreamBuilder<List<Module>>(
              stream: ModuleService().getModulesStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                // --- UPDATED FILTERING LOGIC ---
                final filtered = snapshot.data!.where((m) {
                  // 1. Check search query
                  final matchesQuery = m.title.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  );

                  // 2. Check if already linked to this subject
                  final isNotLinked = !widget.alreadyLinked.any(
                    (linked) => linked.id == m.id,
                  );

                  return matchesQuery && isNotLinked;
                }).toList();
                // -------------------------------

                if (filtered.isEmpty && _searchQuery.isNotEmpty) {
                  return Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        widget.onCreateNew(_searchQuery);
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.add),
                      label: Text("Create '$_searchQuery'"),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, i) => ListTile(
                    leading: const Icon(Icons.inventory_2_outlined),
                    title: Text(filtered[i].title),
                    subtitle: Text(
                      filtered[i].subject != null
                          ? "Currently in: ${filtered[i].subject!.title}"
                          : "Unlinked",
                    ),
                    onTap: () {
                      widget.onModuleSelected(filtered[i]);
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
