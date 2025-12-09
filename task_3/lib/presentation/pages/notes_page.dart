import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_3/core/colors/colors_list.dart';
import 'package:task_3/presentation/cubits/notes_cubit.dart';
import 'package:task_3/presentation/pages/note_editing_page.dart';

import '../../core/network/connectivity_bloc.dart';
import '../../core/theme/theme_cubit.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {

  @override
  void initState() {
    super.initState();
    context.read<NotesCubit>().fetchNotes();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NoteEditingPage()),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        icon: Icon(Icons.add, color: Theme.of(context).colorScheme.secondary,),
        label: Text('Add Note', style: Theme.of(context).textTheme.labelMedium),
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
                Row(
                  children: [
                    BlocBuilder<ConnectivityBloc, ConnectivityState>(
                      builder: (context, state) {
                        return (state is ConnectivityOnline) ? Icon(Icons.wifi, color: Theme.of(context).colorScheme.secondary,)
                            : Icon(Icons.wifi_off, color: Theme.of(context).colorScheme.secondary,);
                      },
                    ),
                    SizedBox(width: 10,),
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
                    ),
                  ],
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
          SliverToBoxAdapter(
            child: BlocListener<ConnectivityBloc, ConnectivityState>(
              listener: (context, state) {
                if(state is ConnectivityOnline) {
                  context.read<NotesCubit>().updateOnNetwork();
                }
              },
              child: BlocBuilder<NotesCubit, NotesState>(
                  builder: (context, state) {
                    if(state is NotesEmpty) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height - 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.note_add_outlined, size: 100, color: Theme.of(context).colorScheme.secondary),
                            SizedBox(height: 10,),
                            Text('No notes yet', style: Theme.of(context).textTheme.headlineSmall),
                            SizedBox(height: 10,),
                            Text('Add a new note to get started', style: Theme.of(context).textTheme.labelMedium),
                          ]
                        ),
                      );
                    } else if(state is NotesLoading) {
                      return SizedBox(
                          height: MediaQuery.of(context).size.height - 200,
                          child: Center(child: CircularProgressIndicator())
                      );
                    } else if(state is NotesLoaded) {
                      ColorList colors = ColorList();
                      return GridView.builder(
                          padding: EdgeInsets.symmetric(horizontal:10),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.8
                          ),
                          itemCount: state.notes.length,
                          itemBuilder: (context, index) {
                            DateTime updated = state.notes[index].updated!;
                            String date = '${updated.day}/${updated.month}/${updated.year}';
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => NoteEditingPage(note: state.notes[index])),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: colors.getColor(state.notes[index].colorId, context),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(color: Colors.black.withAlpha(30), blurRadius: 5, offset: const Offset(0, 2))
                                  ]
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(state.notes[index].title, style: Theme.of(context).textTheme.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis,),
                                    SizedBox(height: 5,),
                                    Expanded(child: Text(state.notes[index].content, style: Theme.of(context).textTheme.bodyMedium, maxLines: 6, overflow: TextOverflow.fade, )),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(date, style: Theme.of(context).textTheme.labelMedium,),
                                        (state.notes[index].status == 1) ? Icon(Icons.cloud_done, size: 18,)
                                            : Icon(Icons.cloud_off, size: 18,)
                                      ],
                                    )
                                  ]
                                ),
                              ),
                            );
                          }
                      );
                    } else {
                      return Center(
                        child: Text('Something went wrong'),
                      );
                    }
                  }
                )
            )
          )
        ]
      ),
    );
  }
}
