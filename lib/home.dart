import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskmanager/task_bloc.dart';


class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state is TaskLoadingState) {
          return Center(child: CircularProgressIndicator());
        } else if (state is TaskLoadedState) {
          // Display tasks
          return Text('Tasks loaded: ${state.tasks.length}');
        } else if (state is TaskErrorState) {
          return Center(child: Text('Error: ${state.error}'));
        }
        return Container();
      },
    );
  }
}
