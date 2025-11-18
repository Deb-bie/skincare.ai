import 'package:flutter/material.dart';

class AddReminder extends StatefulWidget {
  const AddReminder({super.key});

  @override
  State<AddReminder> createState() => _AddReminderState();
}

class _AddReminderState extends State<AddReminder> {
  String selectedRoutine = 'Morning';
  int selectedHour = 7;
  int selectedMinute = 30;
  String selectedPeriod = 'AM';
  final TextEditingController noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      appBar: AppBar(
        backgroundColor: Colors.transparent,

        leading: IconButton(
          icon: const Icon(
              Icons.arrow_back
          ),

          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          'New Reminder',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
            fontFamily: "Poppins",
          ),
        ),
      ),

      body: SingleChildScrollView(

        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              _buildRoutineSection(),
              const SizedBox(height: 32),

              _buildTimeSection(),
              const SizedBox(height: 32),

              _buildNoteSection(),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),

      floatingActionButton: _buildSaveButton(),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildRoutineSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Routine',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
            fontFamily: "Poppins",
          ),
        ),

        const SizedBox(height: 16),

        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(30),
            // border:
          ),

          child: Row(

            children: [

              Expanded(
                child: _buildRoutineButton('Morning'),
              ),

              Expanded(
                child: _buildRoutineButton('Evening'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRoutineButton(String routine) {
    final isSelected = selectedRoutine == routine;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRoutine = routine;
        });
      },

      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),

        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          boxShadow: isSelected
              ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
          ] : [],
        ),
        child: Center(
          child: Text(
            routine,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? Colors.black87 : Colors.black45,
              fontFamily: "Poppins",
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Time',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
            fontFamily: "Poppins",
          ),
        ),

        const SizedBox(height: 16),

        Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [

              Expanded(
                child: _buildTimePicker(
                  items: List.generate(12, (index) => index + 1),
                  selectedValue: selectedHour,
                  onChanged: (value) {
                    setState(() {
                      selectedHour = value;
                    });
                  },
                ),
              ),

              Expanded(
                child: _buildTimePicker(
                  items: List.generate(60, (index) => index),
                  selectedValue: selectedMinute,
                  onChanged: (value) {
                    setState(() {
                      selectedMinute = value;
                    });
                  },
                ),
              ),

              Expanded(
                child: _buildPeriodPicker(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimePicker({
    required List<int> items,
    required int selectedValue,
    required Function(int) onChanged,
  }) {
    return Stack(
      children: [
        ListWheelScrollView.useDelegate(
          itemExtent: 60,
          perspective: 0.005,
          diameterRatio: 1.5,
          physics: const FixedExtentScrollPhysics(),
          onSelectedItemChanged: (index) {
            onChanged(items[index]);
          },
          childDelegate: ListWheelChildBuilderDelegate(
            childCount: items.length,
            builder: (context, index) {
              final value = items[index];
              final isSelected = value == selectedValue;
              return Center(
                child: Text(
                  value.toString().padLeft(2, '0'),
                  style: TextStyle(
                    fontSize: isSelected ? 28 : 16,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                    color: isSelected ? Colors.black87 : Colors.black26,
                    fontFamily: "Poppins",
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPeriodPicker() {
    final periods = ['AM', 'PM'];
    return Stack(
      children: [
        ListWheelScrollView.useDelegate(
          itemExtent: 60,
          perspective: 0.005,
          diameterRatio: 1.5,
          physics: const FixedExtentScrollPhysics(),
          onSelectedItemChanged: (index) {
            setState(() {
              selectedPeriod = periods[index];
            });
          },
          childDelegate: ListWheelChildBuilderDelegate(
            childCount: periods.length,
            builder: (context, index) {
              final period = periods[index];
              final isSelected = period == selectedPeriod;
              return Center(
                child: Text(
                  period,
                  style: TextStyle(
                    fontSize: isSelected ? 28 : 16,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                    color: isSelected ? Colors.black87 : Colors.black26,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNoteSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Note (Optional)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
            fontFamily: "Poppins"
          ),
        ),

        const SizedBox(height: 16),

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextField(
            controller: noteController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Add a note...',
              hintStyle: TextStyle(
                color: Colors.black26,
                fontSize: 13,
                fontFamily: "Poppins"
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Handle save reminder
          print('Routine: $selectedRoutine');
          print('Time: $selectedHour:${selectedMinute.toString().padLeft(2, '0')} $selectedPeriod');
          print('Note: ${noteController.text}');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          shadowColor: const Color(0xFF00D9D9).withOpacity(0.3),
        ),
        child: const Text(
          'Save Reminder',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: "Poppins",
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }
}
