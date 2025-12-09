import 'package:flutter/material.dart';

import '../../core/colors/colors_list.dart';

class NoteEditingPage extends StatefulWidget {
  const NoteEditingPage({super.key});

  @override
  State<NoteEditingPage> createState() => _NoteEditingPageState();
}

class _NoteEditingPageState extends State<NoteEditingPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  int _selectedColorIndex = 0;

  late List<Color> _colors = [];

  @override
  void initState() {
    super.initState();
    var colorsList = ColorList();
    _colors = colorsList.getList().map((color) => color.color).toList();
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
        title: Text(
          'New Note',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              visualDensity: VisualDensity.compact,
              icon: Icon(Icons.save, color: Theme.of(context).colorScheme.secondary),
              onPressed: () {
                // Save note logic
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                style: Theme.of(context).textTheme.titleLarge,
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

              TextField(
                controller: _contentController,
                style: Theme.of(context).textTheme.bodyLarge,
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
    );
  }
}