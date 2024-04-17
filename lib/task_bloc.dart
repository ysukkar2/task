import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskmanager/task_model.dart';
import 'package:taskmanager/task_repository.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final _repository = TaskRepository();

  TaskBloc() : super(TaskLoadingState());

  @override
  Stream<TaskState> mapEventToState(TaskEvent event) async* {
    if (event is LoadTasks) {
      yield TaskLoadingState();
      try {
        final tasks = await _repository.getTasks();
        yield TaskLoadedState(tasks);
      } catch (e) {
        yield TaskErrorState(e.toString());
      }
    }

    if (event is AddTask) {
      try {
        await _repository.addTask(event.task);
        add(LoadTasks());
      } catch (e) {
        yield TaskErrorState(e.toString());
      }
    }

    if (event is UpdateTask) {
      try {
        await _repository.updateTask(event.task);
        add(LoadTasks());
      } catch (e) {
        yield TaskErrorState(e.toString());
      }
    }

    if (event is DeleteTask) {
      try {
        await _repository.deleteTask(event.id);
        add(LoadTasks());
      } catch (e) {
        yield TaskErrorState(e.toString());
      }
    }
  }
}

abstract class TaskEvent {}

class LoadTasks extends TaskEvent {}

class AddTask extends TaskEvent {
  final Task task;

  AddTask(this.task);
}

class UpdateTask extends TaskEvent {
  final Task task;

  UpdateTask(this.task);
}

class DeleteTask extends TaskEvent {
  final int id;

  DeleteTask(this.id);
}

abstract class TaskState {}

class TaskLoadingState extends TaskState {}

class TaskLoadedState extends TaskState {
  final List<Task> tasks;

  TaskLoadedState(this.tasks);
}

class TaskErrorState extends TaskState {
  final String error;

  TaskErrorState(this.error);
}
