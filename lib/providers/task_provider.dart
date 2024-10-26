import 'package:flutter/foundation.dart';
import 'package:to_do_list_app/database_helper.dart';
import '../models/task.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];

  // Ambil hanya tugas yang tidak dihapus
  List<Task> get tasks => _tasks.where((task) => !task.isDeleted).toList();

  // Ambil hanya tugas yang berada di bin
  List<Task> get binTasks => _tasks.where((task) => task.isDeleted).toList();

  TaskProvider() {
    loadTasks();
  }

  Future<void> loadTasks() async {
    _tasks = await DatabaseHelper().getTasks();
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    int newId = await DatabaseHelper().insertTask(task);
    task.id = newId;
    _tasks.add(task);
    notifyListeners();
  }

  Future<void> updateTask(Task updatedTask) async {
    if (updatedTask.id != null) {
      await DatabaseHelper().updateTask(updatedTask);

      // Temukan index task yang akan diupdate
      final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
      if (index != -1) {
        // Update task yang ada
        _tasks[index] = updatedTask;
        notifyListeners();
      }
    }
  }

  Future<void> moveToBin(Task task) async {
    if (task.id != null) {
      final updatedTask = task.copyWith(isDeleted: true);
      await updateTask(updatedTask);
    }
  }

  Future<void> restoreFromBin(Task task) async {
    if (task.id != null) {
      final updatedTask = task.copyWith(isDeleted: false);
      await updateTask(updatedTask);
    }
  }

  Future<void> deletePermanently(Task task) async {
    if (task.id != null) {
      await DatabaseHelper().deleteTask(task.id!);
      _tasks.removeWhere((t) => t.id == task.id);
      notifyListeners();
    }
  }

  Future<void> clearBin() async {
    final tasksToDelete = binTasks; // Ambil tugas yang berada di bin
    for (Task task in tasksToDelete) {
      if (task.id != null) {
        await DatabaseHelper().deleteTask(task.id!);
      }
    }
    _tasks.removeWhere((task) => task.isDeleted); // Hapus tugas yang dihapus dari list
    notifyListeners();
  }

  Future<void> toggleTaskCompletion(Task task) async {
    if (task.id != null) {
      final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
      await updateTask(updatedTask);
    }
  }

  void removeTask(Task task) {
    // Method ini bisa diimplementasikan jika diperlukan
    // Misalnya untuk memindahkan tugas ke bin
    moveToBin(task);
  }
}
