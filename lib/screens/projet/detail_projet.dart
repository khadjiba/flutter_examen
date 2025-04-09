import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/comment_model.dart';
import '../../models/project_model.dart';
import '../tache_list_screen.dart';

class DetailProjet extends StatefulWidget {
  final ProjectModel project;

  const DetailProjet({super.key, required this.project});

  @override
  _DetailProjetState createState() => _DetailProjetState();
}

class _DetailProjetState extends State<DetailProjet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  double _getProgressValue(String status) {
    switch (status) {
      case 'En attente':
        return 0.0;
      case 'En cours':
        return 0.5;
      case 'Terminé':
        return 1.0;
      case 'Annulé':
        return 0.0;
      default:
        return 0.0;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "En attente":
        return Colors.orange;
      case "En cours":
        return Colors.blue;
      case "Terminé":
        return Colors.green;
      case "Annulé":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.project.titre,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: "Aperçu"),
            Tab(text: "Tâches"),
            Tab(text: "Membres"),
            Tab(text: "Fichiers"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          TacheListScreen(projectId: widget.project.id),
          //const MembersList(),
          //const ProjectFilesScreen(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          _buildProjectInfoCard(),
          const SizedBox(height: 10),
          _buildProgressCard(),
          const SizedBox(height: 10),
          _buildStatusSelector(),
        ],
      ),
    );
  }

  Widget _buildProjectInfoCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre et badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.project.titre,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                _buildStatusBadge(widget.project.statut),
              ],
            ),
            const SizedBox(height: 5),
            // Priorité
            Row(
              children: const [
                Icon(Icons.priority_high, color: Colors.orange, size: 18),
                SizedBox(width: 5),
                Text(
                  "Priorité: Haute",
                  style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Description
            const Text("Description", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(widget.project.description),
            const SizedBox(height: 10),
            // Dates
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 5),
                Text("Début: ${DateFormat('dd/MM/yyyy').format(widget.project.createdAt)}"),
                const SizedBox(width: 15),
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 5),
                Text("Fin: ${DateFormat('dd/MM/yyyy').format(widget.project.createdAt)}"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard() {
    double progress = _getProgressValue(widget.project.statut);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Avancement du projet", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Center(child: _buildProgressChart(progress)),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressChart(double progress) {
    return SizedBox(
      width: 150,
      height: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 180,
            height: 180,
            child: CircularProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              strokeWidth: 16,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ),
          Text(
            "${(progress * 100).toInt()}%",
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSelector() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Changer le statut du projet", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: _statusButton("En attente", Colors.orange)),
                Flexible(child: _statusButton("En cours", Colors.blue)),
                Flexible(child: _statusButton("Terminé", Colors.green)),
                Flexible(child: _statusButton("Annulé", Colors.red)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusButton(String status, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(horizontal: 5),
          minimumSize: const Size(80, 30),
        ),
        onPressed: () {
          setState(() {
            widget.project.statut = status;
          });
        },
        child: FittedBox(
          child: Text(status, style: const TextStyle(color: Colors.white, fontSize: 14)),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(status, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
    );
  }
}
