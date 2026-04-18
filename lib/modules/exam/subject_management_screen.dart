// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:polaris/modules/exam/exam.dart';
// import 'package:polaris/modules/exam/exam_service.dart';
// import 'package:polaris/modules/subject/model/subject_snapshot.dart';
// import 'package:uuid/uuid.dart';

// class SubjectManagementScreen extends StatefulWidget {
//   final Exam exam;
//   const SubjectManagementScreen({super.key, required this.exam});

//   @override
//   State<SubjectManagementScreen> createState() =>
//       _SubjectManagementScreenState();
// }

// class _SubjectManagementScreenState extends State<SubjectManagementScreen> {
//   final ExamService _examService = ExamService();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Master Subject List")),
//       body: ListView.builder(
//         itemCount: widget.exam.subjects.length,
//         itemBuilder: (context, index) {
//           final s = widget.exam.subjects[index];
//           return ListTile(
//             leading: const Icon(Icons.category_outlined),
//             title: Text(s.title),
//             trailing: IconButton(
//               icon: const Icon(Icons.delete_outline),
//               onPressed: () async {
//                 setState(() => widget.exam.subjects.removeAt(index));
//                 await _examService.updateExam(widget.exam);
//               },
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: const Icon(Icons.add),
//         onPressed: () {
//           final controller = TextEditingController();
//           showDialog(
//             context: context,
//             builder: (ctx) => AlertDialog(
//               title: const Text("Add Master Subject"),
//               content: TextField(
//                 controller: controller,
//                 decoration: const InputDecoration(
//                   hintText: "e.g. Modern History",
//                 ),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () => context.pop(),
//                   child: const Text("Cancel"),
//                 ),
//                 TextButton(
//                   onPressed: () async {
//                     setState(
//                       () => widget.exam.subjects.add(
//                         SubjectSnapshot(
//                           id: const Uuid().v4(),
//                           title: controller.text,
//                         ),
//                       ),
//                     );
//                     await _examService.updateExam(widget.exam);
//                     if (ctx.mounted) Navigator.pop(ctx);
//                   },
//                   child: const Text("Save"),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
