import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

import '../../main.dart';
import '../../model/task.dart';
import '../../util/colors.dart';
import '../../util// constanst.dart';
import '../../util//strings.dart';

class TaskView extends StatefulWidget {
  const TaskView({
    super.key,
    required this.taskControllerForTitle,
    required this.taskControllerForSubtitle,
    required this.task,
  });

  final TextEditingController? taskControllerForTitle;
  final TextEditingController? taskControllerForSubtitle;
  final Task? task;

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  String? title;
  String? subtitle;
  DateTime? time;
  DateTime? date;

  String showTime(DateTime? time) {
    if (widget.task?.createdAtTime == null) {
      return DateFormat('hh:mm a').format(time ?? DateTime.now()).toString();
    } else {
      return DateFormat('hh:mm a')
          .format(widget.task!.createdAtTime)
          .toString();
    }
  }

  DateTime showTimeAsDateTime(DateTime? time) {
    return widget.task?.createdAtTime ?? (time ?? DateTime.now());
  }

  String showDate(DateTime? date) {
    if (widget.task?.createdAtDate == null) {
      return DateFormat.yMMMEd().format(date ?? DateTime.now()).toString();
    } else {
      return DateFormat.yMMMEd().format(widget.task!.createdAtDate).toString();
    }
  }

  DateTime showDateAsDateTime(DateTime? date) {
    return widget.task?.createdAtDate ?? (date ?? DateTime.now());
  }

  bool isTaskAlreadyExistBool() {
    return widget.taskControllerForTitle?.text.isEmpty ??
        true && widget.taskControllerForSubtitle!.text.isEmpty ??
        true;
  }

  void isTaskAlreadyExistUpdateTask() {
    if (widget.taskControllerForTitle != null &&
        widget.taskControllerForSubtitle != null) {
      try {
        widget.taskControllerForTitle?.text = title ?? '';
        widget.taskControllerForSubtitle?.text = subtitle ?? '';

        widget.task?.createdAtDate = date!;
        widget.task?.createdAtTime = time!;

        widget.task?.save();
        Navigator.of(context).pop();
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update task.')),
        );
      }
    } else {
      if (title != null && subtitle != null) {
        var task = Task.create(
          title: title!,
          createdAtTime: time,
          createdAtDate: date,
          subtitle: subtitle!,
        );
        BaseWidget.of(context).dataStore.addTask(task: task);
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all fields.')),
        );
      }
    }
  }

  void deleteTask() {
    if (widget.task != null) {
      widget.task!.delete();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const MyAppBar(),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildTopText(textTheme),
                  _buildMiddleTextFieldsANDTimeAndDateSelection(
                      context, textTheme),
                  _buildBottomButtons(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding _buildBottomButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: isTaskAlreadyExistBool()
            ? MainAxisAlignment.center
            : MainAxisAlignment.spaceEvenly,
        children: [
          if (!isTaskAlreadyExistBool())
            Container(
              width: 150,
              height: 55,
              decoration: BoxDecoration(
                border: Border.all(color: MyColors.primaryColor, width: 2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                minWidth: 150,
                height: 55,
                onPressed: deleteTask,
                color: Colors.white,
                child: const Row(
                  children: [
                    Icon(Icons.close, color: MyColors.primaryColor),
                    SizedBox(width: 5),
                    Text(MyString.deleteTask,
                        style: TextStyle(color: MyColors.primaryColor)),
                  ],
                ),
              ),
            ),
          MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            minWidth: 150,
            height: 55,
            onPressed: isTaskAlreadyExistUpdateTask,
            color: MyColors.primaryColor,
            child: Text(
              isTaskAlreadyExistBool()
                  ? MyString.addTaskString
                  : MyString.updateTaskString,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  SizedBox _buildMiddleTextFieldsANDTimeAndDateSelection(
      BuildContext context, TextTheme textTheme) {
    return SizedBox(
      width: double.infinity,
      height: 535,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Text(MyString.titleOfTitleTextField,
                style: textTheme.headlineMedium),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: ListTile(
              title: TextFormField(
                controller: widget.taskControllerForTitle,
                maxLines: 6,
                cursorHeight: 60,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                onFieldSubmitted: (value) {
                  title = value;
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                onChanged: (value) {
                  title = value;
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: ListTile(
              title: TextFormField(
                controller: widget.taskControllerForSubtitle,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.bookmark_border, color: Colors.grey),
                  border: InputBorder.none,
                  hintText: MyString.addNote,
                ),
                onFieldSubmitted: (value) {
                  subtitle = value;
                },
                onChanged: (value) {
                  subtitle = value;
                },
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              DatePicker.showTimePicker(
                context,
                showTitleActions: true,
                showSecondsColumn: false,
                onChanged: (_) {},
                onConfirm: (selectedTime) {
                  setState(() {
                    time = selectedTime;
                  });
                },
                currentTime: showTimeAsDateTime(time),
              );
            },
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(MyString.timeString,
                        style: textTheme.headlineSmall),
                  ),
                  Expanded(child: Container()),
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    width: 80,
                    height: 35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade100),
                    child: Center(
                      child: Text(
                        showTime(time),
                        style: textTheme.titleSmall,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          /// Date Picker
          GestureDetector(
            onTap: () {
              DatePicker.showDatePicker(context,
                  showTitleActions: true,
                  minTime: DateTime.now(),
                  maxTime: DateTime(2030, 3, 5),
                  onChanged: (_) {}, onConfirm: (selectedDate) {
                setState(() {
                  if (widget.task?.createdAtDate == null) {
                    date = selectedDate;
                  } else {
                    widget.task!.createdAtDate = selectedDate;
                  }
                });
                FocusManager.instance.primaryFocus?.unfocus();
              }, currentTime: showDateAsDateTime(date));
            },
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(MyString.dateString,
                        style: textTheme.headlineSmall),
                  ),
                  Expanded(child: Container()),
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    width: 140,
                    height: 35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade100),
                    child: Center(
                      child: Text(
                        showDate(date),
                        style: textTheme.titleSmall,
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  /// new / update Task Text
  SizedBox _buildTopText(TextTheme textTheme) {
    return SizedBox(
      width: double.infinity,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 70,
            child: Divider(
              thickness: 2,
            ),
          ),
          RichText(
            text: TextSpan(
                text: isTaskAlreadyExistBool()
                    ? MyString.addNewTask
                    : MyString.updateCurrentTask,
                style: textTheme.titleLarge,
                children: const [
                  TextSpan(
                    text: MyString.taskStrnig,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ]),
          ),
          const SizedBox(
            width: 70,
            child: Divider(
              thickness: 2,
            ),
          ),
        ],
      ),
    );
  }
}

/// AppBar
class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  const MyAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 150,
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 50,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}
