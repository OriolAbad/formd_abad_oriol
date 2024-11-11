import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FormD - Abad Oriol',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );
      },
      child: Scaffold(
        backgroundColor: Colors.blue.shade900,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'M08',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'D',
                style: TextStyle(
                  fontSize: 150,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'Form',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();

  MyHomePage({super.key});

  final List<String> countries = [
    'Argentina',
    'Australia',
    'Belgium',
    'Brazil',
    'Canada',
    'China',
    'France',
    'Germany',
    'India',
    'Italy',
    'Japan',
    'Mexico',
    'Netherlands',
    'Russia',
    'South Korea',
    'United Kingdom',
    'United States',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Formulari Exemple"),
        backgroundColor: Colors.lightBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            children: <Widget>[
              FormTitle(title: 'Formulari Exemple'),
              SizedBox(height: 16),

              // Autocomplete with countries list
              FormLabelGroup(label: 'Selecciona un país'),
              Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  return countries.where((country) => country
                      .toLowerCase()
                      .contains(textEditingValue.text.toLowerCase()));
                },
                onSelected: (String selection) {
                  print('Seleccionado: $selection');
                },
                fieldViewBuilder:
                    (context, controller, focusNode, onEditingComplete) {
                  return FormBuilderTextField(
                    name: 'autocomplete_field',
                    controller: controller,
                    focusNode: focusNode,
                    onEditingComplete: onEditingComplete,
                    decoration: InputDecoration(
                      labelText: 'Escriu un país',
                    ),
                  );
                },
              ),
              SizedBox(height: 16),

              // DatePicker with firstDate and lastDate
              FormLabelGroup(label: 'Selecciona una data'),
              FormBuilderDateTimePicker(
                name: 'date_picker',
                inputType: InputType.date,
                firstDate: DateTime(2020),
                lastDate: DateTime(2025),
                decoration: InputDecoration(
                  labelText: 'Selecciona una data',
                ),
              ),
              SizedBox(height: 16),

              // DateRangePicker with firstDate and lastDate
              FormLabelGroup(label: 'Selecciona un rang de dates'),
              FormBuilderDateRangePicker(
                name: 'date_range_picker',
                firstDate: DateTime(2020),
                lastDate: DateTime(2025),
                decoration: InputDecoration(
                  labelText: 'Selecciona un rang de dates',
                ),
              ),
              SizedBox(height: 16),

              // TimePicker
              FormLabelGroup(label: 'Selecciona una hora'),
              FormBuilderDateTimePicker(
                name: 'time_picker',
                inputType: InputType.time,
                decoration: InputDecoration(
                  labelText: 'Selecciona una hora',
                ),
              ),
              SizedBox(height: 16),

              // Input Chips (Filter Chip) - manually implemented
              FormLabelGroup(label: 'Selecciona opcions'),
              Container(
                child: FilterChipInput(
                  name: 'input_chips',
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState?.saveAndValidate() ?? false) {
            // Make a mutable copy of the form values
            final formValues = Map<String, dynamic>.from(_formKey.currentState?.value ?? {});

            String summary = 'Resumen de las opciones seleccionadas:\n';
            summary += 'Autocomplete: ${formValues['autocomplete_field']}\n';
            summary += 'Date Picker: ${formValues['date_picker']}\n';
            summary += 'Date Range: ${formValues['date_range_picker']}\n';
            summary += 'Time Picker: ${formValues['time_picker']}\n';
            summary += 'Input Chips: ${formValues['input_chips']?.join(", ")}';

            alertDialog(context, summary);
          } else {
            print("Validació fallida");
            alertDialog(context, "Error en la validación.");
          }
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.send),
      ),
    );
  }
}

void alertDialog(BuildContext context, String contentText) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text("Formulari enviat!"),
      icon: const Icon(Icons.check_circle),
      content: Text(contentText),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cerrar'),
        ),
      ],
    ),
  );
}

class FormLabelGroup extends StatelessWidget {
  final String label;
  const FormLabelGroup({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        label,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class FormTitle extends StatelessWidget {
  final String title;
  const FormTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }
}

class FilterChipInput extends StatefulWidget {
  final String name;
  const FilterChipInput({super.key, required this.name});

  @override
  _FilterChipInputState createState() => _FilterChipInputState();
}

class _FilterChipInputState extends State<FilterChipInput> {
  List<String> _selectedOptions = [];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      children: ['Opció 1', 'Opció 2', 'Opció 3', 'Opció 4'].map((option) {
        return FilterChip(
          label: Text(option),
          selected: _selectedOptions.contains(option),
          onSelected: (bool selected) {
            setState(() {
              if (selected) {
                _selectedOptions.add(option);
              } else {
                _selectedOptions.remove(option);
              }
            });
          },
        );
      }).toList(),
    );
  }
}
