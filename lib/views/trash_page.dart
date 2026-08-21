import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/notes_cubit/notes_cubit.dart';
import '../cubits/notes_cubit/notes_state.dart';

class TrashPage extends StatefulWidget {
  const TrashPage({super.key});

  @override
  State<TrashPage> createState() => _TrashPageState();
}

class _TrashPageState extends State<TrashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<NotesCubit>(context).fetchDeletedones(); 
    });
  }    

  // [تحسين 1]: دالة إظهار نافذة التأكيد قبل الحذف النهائي

  Future<bool?> _showDeleteConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 138, 128, 168),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Confirm final deletion',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
          content: const Text(
            'Item/s will be permanently deleted from the cloud and all your devices.',
            style: TextStyle(color: Colors.white),
          ),
         actions: [
          ElevatedButton(
          style: ElevatedButton.styleFrom(
      backgroundColor: Color.fromARGB(255, 138, 128, 168),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    onPressed: () => Navigator.of(context).pop(false),
    child: const Text('Cancel'),
  ),

  ElevatedButton(
        style: ElevatedButton.styleFrom(
      backgroundColor: Color.fromARGB(255, 138, 128, 168),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    onPressed: () => Navigator.of(context).pop(true),
    child: const Text('Delete'),
  ),
],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F5FC),
      appBar: AppBar(
        backgroundColor: const Color(0xffF8F5FC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Deleted Notes',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<NotesCubit, NotesState>(
        builder: (context, state) {
          if (state is NotesSuccess) {
            final deletedNotes = state.notes;

            //  الشاشة الفارغة المتفاعلة (Empty State)

            if (deletedNotes.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.delete_outline_rounded,
                      size: 80,
                      color: Color(0xffA095C1),
                    ),
                    SizedBox(height: 16),
                    Text(
                      ' The trash is empty ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'No notes or folders',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: deletedNotes.length,
              itemBuilder: (context, index) {
                final note = deletedNotes[index];

                //  خاصية المسح للسحب (Dismissible)

                return Dismissible(
                  key: Key(note.key.toString()), 

                  // خلفية السحب لليمين (استرجاع)

                  background: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade400,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: const [
                        Icon(Icons.restore, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Restore',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // خلفية السحب لليسار (حذف نهائي)
                  secondaryBackground: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade400,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        Text(
                          'Delete forever ',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.delete_forever, color: Colors.white),
                      ],
                    ),
                  ),

                  // التأكد والتحكم قبل إتمام الحركة

                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.endToStart) {
                      // سحب لليسار -> إظهار نافذة التأكيد قبل الحذف النهائي
                      return await _showDeleteConfirmationDialog(context);
                    } else {
                      // سحب لليمين -> استرجاع مباشر
                      return true;
                    }
                  },
                  onDismissed: (direction) {
                    if (direction == DismissDirection.endToStart) {
                      BlocProvider.of<NotesCubit>(context).Deletpermenant(note);
                    } else {
                      BlocProvider.of<NotesCubit>(context).Restoring(note);
                    }
                  },
                  child: Card(
                    color: const Color(0xffE2DCF2),
                    elevation: 1,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      title: Text(
                        note.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        note.content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.restore, color: Colors.green),
                            onPressed: () {
                              BlocProvider.of<NotesCubit>(context).Restoring(note);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_forever, color: Colors.red),
                            onPressed: () async {
                              final shouldDelete =
                                  await _showDeleteConfirmationDialog(context);
                              if (shouldDelete == true) {
                                if (context.mounted) {
                                  BlocProvider.of<NotesCubit>(context)
                                      .Deletpermenant(note);
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state is NotesFailure) {
            return Center(child: Text(state.errorMessage));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}