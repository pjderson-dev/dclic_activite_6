import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Importation de Google Fonts
import 'database_helper.dart';
import 'note_edit_page.dart';

class NotesListPage extends StatefulWidget {
  const NotesListPage({super.key});

  @override
  _NotesListPageState createState() => _NotesListPageState();
}

class _NotesListPageState extends State<NotesListPage> {
  final dbHelper = DatabaseHelper();
  late Future<List<Map<String, dynamic>>> _notesFuture;

  @override
  void initState() {
    super.initState();
    _refreshNotesList();
  }

  void _refreshNotesList() {
    setState(() {
      _notesFuture = dbHelper.getAllNotes();
    });
  }

  void _navigateToEditPage({int? noteId}) async {
    // On attend le retour de la page d'édition pour rafraîchir la liste
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteEditPage(noteId: noteId)),
    );

    // Si la page d'édition a renvoyé "true" (signifiant qu'une note a été sauvegardée ou modifiée), on rafraîchit.
    if (result == true) {
      _refreshNotesList();
    }
  }

  void _deleteNote(int id) async {
    await dbHelper.deleteNote(id);
    _refreshNotesList(); // Rafraîchit la liste pour enlever la note supprimée

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Note supprimée avec succès', style: GoogleFonts.poppins()),
          backgroundColor: Colors.green, // Feedback positif
        ),
      );
    }
  }

  // --- Dialogue de confirmation stylisé ---
  void _showDeleteConfirmationDialog(int noteId, String noteTitle) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Confirmer la suppression', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          content: RichText(
            text: TextSpan(
              style: GoogleFonts.poppins(color: Colors.black87, fontSize: 16),
              children: [
                const TextSpan(text: 'Voulez-vous vraiment supprimer la note '),
                TextSpan(
                  text: '"$noteTitle"',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: ' ?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Annuler', style: GoogleFonts.poppins(color: Colors.grey[700])),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteNote(noteId);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Supprimer', style: GoogleFonts.poppins()),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50], // Cohérence du fond
      appBar: AppBar(
        title: Text(
          "Mes Notes",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: theme.primaryColor,
        elevation: 2,
        automaticallyImplyLeading: false, // Cache toujours le bouton retour
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _notesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: theme.primaryColor));
          }
          if (snapshot.hasError) {
            return Center(child: Text("Erreur: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // --- État vide amélioré ---
            return _buildEmptyState();
          }

          final notes = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              final noteId = note['id'] as int;
              final title = note['title'] as String? ?? 'Sans titre';
              final content = note['content'] as String? ?? 'Pas de contenu';

              // --- Carte de note stylisée ---
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  title: Text(
                    title,
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 17),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Text(
                      content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(color: Colors.grey[700]),
                    ),
                  ),
                  onTap: () => _navigateToEditPage(noteId: noteId),
                  trailing: IconButton(
                    icon: Icon(Icons.delete_outline_rounded, color: Colors.redAccent.withOpacity(0.8)),
                    onPressed: () => _showDeleteConfirmationDialog(noteId, title),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToEditPage(),
        tooltip: 'Ajouter une note',
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: Text("Nouvelle Note", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        elevation: 4,
      ),
    );
  }

  // --- Widget pour l'état vide ---
  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.note_add_outlined,
              size: 100,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 24),
            Text(
              "C'est un peu vide ici...",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Cliquez sur 'Nouvelle Note' pour commencer à écrire.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}