import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
class AddCostPage extends StatefulWidget {
  @override
  _AddCostPageState createState() => _AddCostPageState();
}

class _AddCostPageState extends State<AddCostPage> {
  final _formKey = GlobalKey<FormState>();
  String _entryType = 'expense';
  String _description = '';
  double _amount = 0.0;
  String _expenseType = 'daily';  // Default to daily
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  TextEditingController _amountController = TextEditingController();
  bool _showCustomKeypad = false;
  File? _image;

  Future<void> _takePicture() async {
  final picker = ImagePicker();
  try {
    final pickedImage = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    } else {
      print('No image selected.');
    }
  } catch (e) {
    print('Failed to pick image: $e');
  }
}


  Widget _imagePreview() {
    return Container(
      height: 200,
      width: double.infinity,
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: _image == null
          ? Center(child: Text("No image selected", textAlign: TextAlign.center))
          : Image.file(_image!, fit: BoxFit.cover),
    );
  }

  bool _isFormReadyForSubmission() {
    // Check if the amount is not empty and a date and time have been picked
    return _amountController.text.isNotEmpty && _selectedDate != null && _selectedTime != null;
  }
  // Function to handle date selection
  void _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _pickTime();  // Automatically trigger time picking after date
      });
    }
  }

  // Function to handle time selection
  void _pickTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }
  void _toggleKeypad() {
    setState(() {
      _showCustomKeypad = !_showCustomKeypad;
    });
  }

  void _onKeypadInput(String input) {
    setState(() {
      _amountController.text += input;
    });
  }

  void _onKeypadDelete() {
    setState(() {
      String text = _amountController.text;
      if (text.isNotEmpty) {
        _amountController.text = text.substring(0, text.length - 1);
      }
    });
  }

  void _onKeypadClear() {
    setState(() {
      _amountController.clear();
    });
  }

  void _onKeypadCalculate() {
    Parser p = Parser();
    try {
      Expression exp = p.parse(_amountController.text);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      _amountController.text = eval.toString();
    } catch (e) {
      _amountController.text = "Error";
    }
  }
  // Update the Confirm button to use the new method
  Widget _confirmButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: _isFormReadyForSubmission() ? Color.fromARGB(255, 51, 126, 111) : Colors.grey,
      ),
      onPressed: _isFormReadyForSubmission()
          ? () {
              if (_formKey.currentState?.validate() ?? false) {
                _formKey.currentState?.save();
                // TODO: Insert the logic to handle form submission here
                Navigator.pop(context);
              }
            }
          : null, // This will disable the button when the form isn't ready
      child: Text('Confirm'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Cost'),
        backgroundColor:  Color.fromARGB(255, 51, 126, 111),
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text('Please Choose', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              RadioListTile<String>(
                title: const Text('Expense'),
                value: 'expense',
                groupValue: _entryType,
                onChanged: (value) {
                  setState(() {
                    _entryType = value!;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text('Income'),
                value: 'income',
                groupValue: _entryType,
                onChanged: (value) {
                  setState(() {
                    _entryType = value!;
                  });
                },
              ),
              Divider(),
              Wrap(
                spacing: 10.0,
                runSpacing: 4.0,
                children: <Widget>[
                  _buildExpenseTypeChip(Icons.home, 'Daily'),
                  _buildExpenseTypeChip(Icons.restaurant, 'Eating'),
                  _buildExpenseTypeChip(Icons.shopping_cart, 'Shopping'),
                  _buildExpenseTypeChip(Icons.movie, 'Entertainment'),
                  _buildExpenseTypeChip(Icons.school, 'Study'),
                ],
              ),
              Divider(),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
                onSaved: (value) {
                  _description = value ?? '';
                },
              ),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                ),
                readOnly: true, // Make this field read-only
                onTap: _toggleKeypad, // Toggle the custom keypad on tap
                // (Validator and other properties remain the same)
              ),
              ListTile(
                title: Text('Pick Date and Time'),
                subtitle: Text(
                  _selectedDate == null
                      ? 'No date chosen'
                      : 'Date: ${_selectedDate!.toIso8601String().split('T')[0]} Time: ${_selectedTime?.format(context) ?? ''}'),
                trailing: Icon(Icons.calendar_today),
                onTap: _pickDate,  // Trigger date picker
              ),
               Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.camera_alt),
                    color: Theme.of(context).primaryColor,
                    onPressed: _takePicture,
                  ),
                ],
              ),
              _imagePreview(),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Navigator.pop(context);
                  }
                },
                child: Text('Submit'),
              ),
              _confirmButton(),

              if (_showCustomKeypad) _buildCustomKeypad(),
            ],
          ),
        ),
      ),
    );
  }
 
Widget _buildCustomKeypad() {
  // Style for number buttons
  final buttonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.black, // Text color for buttons
    backgroundColor: Colors.white, // Background color for buttons
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8), // Rounded corners for buttons
    ),
    padding: EdgeInsets.all(20),
  );

  // Style for operator buttons
  final operatorButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.black, // Text color for operator buttons
    backgroundColor: Colors.blue[200], // Background color for operator buttons
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8), // Rounded corners for buttons
    ),
    padding: EdgeInsets.all(20),
  );

  // Creating the button grid
  List<Widget> keypadButtons = [
    // First row: 7, 8, 9, Clear (C)
    ...List.generate(3, (i) => 7 + i).map((number) => ElevatedButton(
      style: buttonStyle,
      onPressed: () => _onKeypadInput('$number'),
      child: Text('$number'),
    )),
    ElevatedButton(
      style: operatorButtonStyle,
      onPressed: _onKeypadClear, // Clear action
      child: Text('C'),
    ),
    
    // Second row: 4, 5, 6, Subtract (-)
    ...List.generate(3, (i) => 4 + i).map((number) => ElevatedButton(
      style: buttonStyle,
      onPressed: () => _onKeypadInput('$number'),
      child: Text('$number'),
    )),
    ElevatedButton(
      style: operatorButtonStyle,
      onPressed: () => _onKeypadInput('-'),
      child: Text('-'),
    ),
    
    // Third row: 1, 2, 3, Add (+)
    ...List.generate(3, (i) => 1 + i).map((number) => ElevatedButton(
      style: buttonStyle,
      onPressed: () => _onKeypadInput('$number'),
      child: Text('$number'),
    )),
    ElevatedButton(
      style: operatorButtonStyle,
      onPressed: () => _onKeypadInput('+'),
      child: Text('+'),
    ),
    
    // Fourth row: Decimal (.), 0, Backspace, Equals (=)
    ElevatedButton(
      style: buttonStyle,
      onPressed: () => _onKeypadInput('.'),
      child: Text('.'),
    ),
    ElevatedButton(
      style: buttonStyle,
      onPressed: () => _onKeypadInput('0'),
      child: Text('0'),
    ),
    ElevatedButton(
      style: operatorButtonStyle,
      onPressed: _onKeypadDelete, // Backspace action
      child: Icon(Icons.backspace),
    ),
    ElevatedButton(
      style: operatorButtonStyle,
      onPressed: _onKeypadCalculate, // Equals action
      child: Text('='),
    ),
  ];

  // Adjusting the layout to have 4 columns
  return GridView.count(
    crossAxisCount: 4,
    mainAxisSpacing: 8,
    crossAxisSpacing: 8,
    padding: const EdgeInsets.all(8),
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(), // Disable GridView scrolling
    children: keypadButtons,
  );
}



  Widget _buildExpenseTypeChip(IconData icon, String label) {
    bool isSelected = _expenseType == label.toLowerCase();
    return ChoiceChip(
      label: Text(label),
      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
      selected: isSelected,
      onSelected: (bool selected) {
        setState(() {
          _expenseType = label.toLowerCase();
        });
      },
      selectedColor:  Color.fromARGB(255, 51, 126, 111),
      avatar: Icon(icon, color: isSelected ? Colors.white : Colors.black),
    );
  }
}
