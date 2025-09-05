import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'database_helper.dart';

class NoteEditPage extends StatefulWidget {
  final int? noteId;

  const NoteEditPage({super.key, this.noteId});

  @override
  _NoteEditPageState createState() => _NoteEditPageState();
}

class _NoteEditPageState extends State<NoteEditPage> {
  final dbHelper = DatabaseHelper();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); 

  bool _isNewNote = true;
  bool _isLoading = false; 

  @override
  void initState() {
    super.initState();
    if (widget.noteId != null) {
      _isNewNote = false;
      _loadNoteData();
    }
  }

  void _loadNoteData() async {
    final note = await dbHelper.getNote(widget.noteId!);
    if (note != null && mounted) {
      setState(() {
        _titleController.text = note['title'];
        _contentController.text = note['content'];
      });
    }
  }

  void _saveNote() async {
    // Valide le formulaire avant de sauvegarder
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String title = _titleController.text.trim();
    String content = _contentController.text.trim();

    // Simule une petite latence
    await Future.delayed(const Duration(milliseconds: 500));

    if (_isNewNote) {
      await dbHelper.createNote(title, content);
    } else {
      await dbHelper.updateNote(widget.noteId!, title, content);
    }
    
    // Retourne à la page précédente avec un indicateur de succès
    if (mounted) {
      Navigator.pop(context, true); 
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          _isNewNote ? "Nouvelle Note" : "Modifier la Note",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: theme.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white), 
        elevation: 2,
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isLoading ? null : _saveNote,
        label: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
              )
            : Text("Enregistrer", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        icon: _isLoading ? null : const Icon(Icons.save_rounded),
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView( 
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form( 
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                
                TextFormField(
                  controller: _titleController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Le titre ne peut pas être vide.';
                    }
                    return null;
                  },
                  style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    hintText: 'Titre',
                    border: InputBorder.none, 
                    counterText: "", 
                  ),
                  maxLength: 50,
                ),
                const SizedBox(height: 16),

          
                TextFormField(
                  controller: _contentController,
                  style: GoogleFonts.poppins(fontSize: 16, height: 1.5),
                  maxLines: null, 
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: 'Commencez à écrire ici...',
                    border: InputBorder.none, 
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