import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_3/presentation/pages/note_editing_page.dart';

import '../../core/theme/theme_cubit.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NoteEditingPage()),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(Icons.add, color: Theme.of(context).colorScheme.secondary,),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 100,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(' Notes', style: Theme.of(context).textTheme.headlineMedium,),
                BlocBuilder<ThemeCubit, ThemeData>(
                    builder: (context, theme) {
                      return IconButton(
                        onPressed: () {
                          context.read<ThemeCubit>().toggleTheme();
                        },
                        icon: (theme.brightness == Brightness.light) ? Icon(Icons.dark_mode) : Icon(Icons.light_mode),
                        color: Theme.of(context).colorScheme.secondary,
                      );
                    }
                )
              ],
            ),
            pinned: false,
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(28), bottomRight: Radius.circular(28),),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(child: Text('Manage your notes in a organized way with beautiful colors.', style: Theme.of(context).textTheme.labelMedium,)),
                  ],
                ),
              ),
            ),
          ),
          SliverFillRemaining()
        ]
      ),
    );
  }
}
