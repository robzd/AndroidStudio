import 'package:flutter/material.dart';

void main() {
  runApp(ConversorDeMedidasApp());
}

class ConversorDeMedidasApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trabalho de DSD',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TelaInicial(),
      routes: {
        '/entrada': (context) => TelaEntrada(),
        '/resultado': (context) => TelaResultado(),
      },
    );
  }
}

class TelaInicial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(
        title: Text('Trabalho de DSD'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Conversor de Medidas by: Robsz',
              style: TextStyle(fontSize: 24, color: Color(0xffff0000)),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/entrada');
              },
              child: Text('Iniciar Conversão'),
            ),
          ],
        ),
      ),
    );
  }
}

class TelaEntrada extends StatefulWidget {
  @override
  _TelaEntradaState createState() => _TelaEntradaState();
}

class _TelaEntradaState extends State<TelaEntrada> {
  final _controller = TextEditingController();
  String _selectedCategory = 'distancia'; // Categoria padrão
  String _selectedConversion = 'km_para_m'; // Conversão padrão

  // Categorias e suas conversões
  final Map<String, Map<String, String>> _categories = {
    'distancia': {
      'km_para_m': 'Quilômetros para Metros',
      'm_para_cm': 'Metros para Centímetros',
      'km_para_milhas': 'Quilômetros para Milhas',
      'm_para_km': 'Metros para Quilômetros',
    },
    'tempo': {
      'horas_para_minutos': 'Horas para Minutos',
      'minutos_para_segundos': 'Minutos para Segundos',
      'dias_para_horas': 'Dias para Horas',
    },
    'temperatura': {
      'c_para_f': 'Celsius para Fahrenheit',
      'f_para_c': 'Fahrenheit para Celsius',
      'c_para_k': 'Celsius para Kelvin',
    },
  };

  void _converter() {
    double valor = double.tryParse(_controller.text) ?? 0.0;
    double resultado = 0.0;

    // Realiza a conversão com base na seleção
    switch (_selectedConversion) {
      // Distância
      case 'km_para_m':
        resultado = valor * 1000; // 1 km = 1000 m
        break;
      case 'm_para_cm':
        resultado = valor * 100; // 1 m = 100 cm
        break;
      case 'km_para_milhas':
        resultado = valor * 0.621371; // 1 km = 0.621371 milhas
        break;
      case 'm_para_km':
        resultado = valor / 1000; // 1 m = 0.001 km
        break;

      // Tempo
      case 'horas_para_minutos':
        resultado = valor * 60; // 1 hora = 60 minutos
        break;
      case 'minutos_para_segundos':
        resultado = valor * 60; // 1 minuto = 60 segundos
        break;
      case 'dias_para_horas':
        resultado = valor * 24; // 1 dia = 24 horas
        break;

      // Temperatura
      case 'c_para_f':
        resultado = (valor * 9 / 5) + 32; // Celsius para Fahrenheit
        break;
      case 'f_para_c':
        resultado = (valor - 32) * 5 / 9; // Fahrenheit para Celsius
        break;
      case 'c_para_k':
        resultado = valor + 273.15; // Celsius para Kelvin
        break;
    }

    Navigator.pushNamed(
      context,
      '/resultado',
      arguments: {
        'resultado': resultado,
        'conversao': _categories[_selectedCategory]![_selectedConversion],
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(
        title: Text('Trabalho de DSD'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown para selecionar a categoria
            DropdownButton<String>(
              value: _selectedCategory,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue!;
                  _selectedConversion = _categories[newValue]!.keys.first;
                });
              },
              items: _categories.keys.map((String key) {
                return DropdownMenuItem<String>(
                  value: key,
                  child: Text(key.toUpperCase()),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            // Dropdown para selecionar a conversão
            DropdownButton<String>(
              value: _selectedConversion,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedConversion = newValue!;
                });
              },
              items: _categories[_selectedCategory]!.entries.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            // Campo de texto para inserir o valor
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Digite o valor',
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            // Botão para converter
            ElevatedButton(
              onPressed: _converter,
              child: Text('Converter'),
            ),
          ],
        ),
      ),
    );
  }
}

class TelaResultado extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final double resultado = args['resultado'];
    final String conversao = args['conversao'];

    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(
        title: Text('Trabalho de DSD'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Conversão: $conversao',
              style: TextStyle(fontSize: 20, color: Color(0xffff0000)),
            ),
            SizedBox(height: 20),
            Text(
              'Resultado: $resultado',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffff0000)),
            ),
            SizedBox(height: 20),
            // Botão para voltar à tela de conversão
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Volta para a tela anterior
              },
              child: Text('Voltar'),
            ),
          ],
        ),
      ),
    );
  }
}
