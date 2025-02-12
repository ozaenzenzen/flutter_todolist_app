class TaskHolderDataEntity {
  String? taskTitle;
  String? deadline;
  DateTime? deadline2;
  String? notes;
  int? status;
  List<TaskListDataEntity>? tasksList;

  TaskHolderDataEntity({
    this.taskTitle,
    this.deadline,
    this.deadline2,
    this.notes,
    this.status,
    this.tasksList,
  });

  // Convert TaskHolderDataEntity to a JSON-compatible map
  Map<String, dynamic> toJson() {
    return {
      'taskTitle': taskTitle,
      'deadline': deadline,
      'deadline2': deadline2?.toIso8601String(), // Convert DateTime to String
      'notes': notes,
      'status': status,
      'tasksList': tasksList?.map((task) => task.toJson()).toList(), // Convert List<TaskListDataEntity> to List<Map>
    };
  }

  // Create a TaskHolderDataEntity from a JSON-compatible map
  factory TaskHolderDataEntity.fromJson(Map<String, dynamic> json) {
    return TaskHolderDataEntity(
      taskTitle: json['taskTitle'],
      deadline: json['deadline'],
      deadline2: json['deadline2'] != null
          ? DateTime.parse(json['deadline2']) // Convert String back to DateTime
          : null,
      notes: json['notes'],
      status: json['status'],
      tasksList: json['tasksList'] != null
          ? (json['tasksList'] as List).map((task) => TaskListDataEntity.fromJson(task)).toList() // Convert List<Map> back to List<TaskListDataEntity>
          : null,
    );
  }
}

class TaskListDataEntity {
  String? text;
  bool? done;

  TaskListDataEntity({
    this.text,
    this.done,
  });

  // Convert TaskListDataEntity to a JSON-compatible map
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'done': done,
    };
  }

  // Create a TaskListDataEntity from a JSON-compatible map
  factory TaskListDataEntity.fromJson(Map<String, dynamic> json) {
    return TaskListDataEntity(
      text: json['text'],
      done: json['done'],
    );
  }
}
