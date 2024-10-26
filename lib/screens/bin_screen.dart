import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';

class BinScreen extends StatelessWidget {
  const BinScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: const Color(0xFF2C3E50),
      title: const Row(
        children: [
          // Icon(Icons.delete_outline, color: Colors.white),
          SizedBox(width: 12),
          Text(
            'Bin',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        Consumer<TaskProvider>(
          builder: (context, taskProvider, child) {
            if (taskProvider.binTasks.isNotEmpty) {
              return IconButton(
                icon: const Icon(Icons.delete_forever, color: Colors.white),
                onPressed: () => _showClearBinDialog(context, taskProvider),
                tooltip: 'Hapus Semua',
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        if (taskProvider.binTasks.isEmpty) {
          return _buildEmptyState();
        }
        return _buildTasksList(context, taskProvider);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.delete_outline,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Tempat Sampah Kosong',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tugas yang dihapus akan muncul di sini',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksList(BuildContext context, TaskProvider taskProvider) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: taskProvider.binTasks.length,
      itemBuilder: (context, index) {
        final task = taskProvider.binTasks[index];
        return _buildTaskCard(context, task, taskProvider);
      },
    );
  }

  Widget _buildTaskCard(BuildContext context, Task task, TaskProvider taskProvider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Dismissible(
          key: Key((task.id ?? '').toString()),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            color: Colors.red,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.delete_forever, color: Colors.white),
                SizedBox(height: 4),
                Text(
                  'Hapus\nPermanen',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
          onDismissed: (direction) {
            taskProvider.deletePermanently(task);
            _showSnackBar(
              context,
              'Tugas telah dihapus secara permanen',
              Icons.delete_forever,
            );
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: task.priorityColor ?? Colors.grey,
                  width: 4,
                ),
              ),
            ),
            child: ExpansionTile(
              title: Text(
                task.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('dd MMM yyyy – HH:mm').format(task.dueDate),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _buildActionButton(
                            context,
                            'Pulihkan',
                            Icons.restore,
                            Colors.green,
                            () {
                              taskProvider.restoreFromBin(task);
                              _showSnackBar(
                                context,
                                'Tugas telah dipulihkan',
                                Icons.restore,
                              );
                            },
                          ),
                          const SizedBox(width: 8),
                          _buildActionButton(
                            context,
                            'Hapus',
                            Icons.delete_forever,
                            Colors.red,
                            () {
                              _showDeleteConfirmationDialog(
                                context,
                                task,
                                taskProvider,
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: onPressed,
    );
  }

  void _showDeleteConfirmationDialog(
    BuildContext context,
    Task task,
    TaskProvider taskProvider,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Permanen'),
          content: const Text(
            'Tugas yang dihapus secara permanen tidak dapat dipulihkan kembali. Lanjutkan?',
          ),
          actions: [
            TextButton(
              child: const Text('Batal'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text(
                'Hapus',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                taskProvider.deletePermanently(task);
                Navigator.of(context).pop();
                _showSnackBar(
                  context,
                  'Tugas telah dihapus secara permanen',
                  Icons.delete_forever,
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showClearBinDialog(BuildContext context, TaskProvider taskProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Kosongkan Tempat Sampah'),
          content: const Text(
            'Semua tugas akan dihapus secara permanen dan tidak dapat dipulihkan kembali. Lanjutkan?',
          ),
          actions: [
            TextButton(
              child: const Text('Batal'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text(
                'Kosongkan',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                taskProvider.clearBin();
                Navigator.of(context).pop();
                _showSnackBar(
                  context,
                  'Tempat sampah telah dikosongkan',
                  Icons.delete_sweep,
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(BuildContext context, String message, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Text(message),
          ],
        ),
      ),
    );
  }
}
