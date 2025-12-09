import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_3/data/db/database.dart';

import '../../core/colors/colors_list.dart';
import '../cubits/notes_cubit.dart';

class NoteEditingPage extends StatefulWidget {
  final NoteItem? note;
  const NoteEditingPage({super.key, this.note});

  @override
  State<NoteEditingPage> createState() => _NoteEditingPageState();
}

class _NoteEditingPageState extends State<NoteEditingPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  int _selectedColorIndex = 0;

  late List<Color> _colors;

  final formKey = GlobalKey<FormState>();
  bool isEditing = false;
  bool isNew = true;
  bool titleEnabled = true;
  bool contentEnabled = true;

  @override
  void initState() {
    super.initState();
    var colorsList = ColorList();
    _colors = colorsList.getList().map((color) => color.color).toList();
    _titleController.text = widget.note?.title ?? '';
    _contentController.text = widget.note?.content ?? '';
    _selectedColorIndex = widget.note?.colorId ?? 0;
    if(widget.note != null){
      isEditing = true;
      isNew = false;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.secondary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if(isNew) Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onTertiary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              visualDensity: VisualDensity.compact,
              icon: Icon(Icons.save, color: Theme.of(context).colorScheme.secondary),
              onPressed: () {
                if(formKey.currentState!.validate()) {
                  context.read<NotesCubit>().addNote(_titleController.text, _contentController.text, _selectedColorIndex);
                  Navigator.pop(context);
                }
              },
            ),
          ),
          if(!isNew) Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onTertiary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              visualDensity: VisualDensity.compact,
              icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.secondary),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Delete Note'),
                      content: Text('Are you sure you want to delete this note?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            context.read<NotesCubit>().deleteNote(widget.note!.id);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: Text('Delete', style: TextStyle(color: Theme.of(context).colorScheme.error),),
                        ),
                      ]
                    );
                  }
                );
              },
            ),
          ),
          if(!isNew) Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onTertiary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              visualDensity: VisualDensity.compact,
              icon: Icon(Icons.check, color: Theme.of(context).colorScheme.secondary),
              onPressed: () {
                if(formKey.currentState!.validate()) {
                  context.read<NotesCubit>().updateNote(widget.note!.id, _titleController.text, _contentController.text, _selectedColorIndex);
                  Navigator.pop(context);
                }
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleController,
                  style: Theme.of(context).textTheme.titleLarge,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Title',
                    hintStyle: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.onError),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const SizedBox(height: 24),

                Text(
                  'COLOR',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 12),

                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: List.generate(_colors.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedColorIndex = index;
                        });
                      },
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: _colors[index],
                          shape: BoxShape.circle,
                          border:Border.all(color: Theme.of(context).colorScheme.secondary, width: 0.5),
                        ),
                        child: _selectedColorIndex == index
                            ? Icon(
                          Icons.check,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 20,
                        )
                            : null,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _contentController,
                  style: Theme.of(context).textTheme.bodyLarge,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some content';
                    }
                    return null;
                  },
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: 'Start typing...',
                    hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onError),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}