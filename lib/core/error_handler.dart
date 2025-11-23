import 'package:flutter/material.dart';

class ErrorHandler {
  static void showError(BuildContext context, String message, {String? title}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red[600],
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                title ?? 'Erro',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        action: SnackBarAction(
          label: 'DETALHES',
          textColor: Colors.white,
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(title ?? 'Erro'),
                content: Text(message),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              ),
            );
          },
        ),
        duration: Duration(seconds: 4),
      ),
    );
  }

  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green[600],
        content: Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.white),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  static void showWarning(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.orange[600],
        content: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.white),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }

  static String handleDatabaseError(dynamic error) {
    if (error.toString().contains('no such table')) {
      return 'Erro de banco de dados: Tabela não encontrada';
    } else if (error.toString().contains('syntax error')) {
      return 'Erro de banco de dados: Erro de sintaxe SQL';
    } else if (error.toString().contains('UNIQUE constraint failed')) {
      return 'Erro de banco de dados: Registro duplicado';
    } else {
      return 'Erro de banco de dados: ${error.toString()}';
    }
  }

  static String handleValidationError(String field, String value) {
    switch (field) {
      case 'salary':
        if (value.isEmpty) return 'Salário não pode estar vazio';
        if (double.tryParse(value) == null) return 'Salário deve ser um número válido';
        if (double.parse(value) <= 0) return 'Salário deve ser maior que zero';
        break;
      case 'year':
        if (value.isEmpty) return 'Ano não pode estar vazio';
        if (int.tryParse(value) == null) return 'Ano deve ser um número válido';
        if (int.parse(value) < 2000 || int.parse(value) > 2100) return 'Ano deve estar entre 2000 e 2100';
        break;
      case 'month':
        if (value.isEmpty) return 'Mês não pode estar vazio';
        if (int.tryParse(value) == null) return 'Mês deve ser um número válido';
        if (int.parse(value) < 1 || int.parse(value) > 12) return 'Mês deve estar entre 1 e 12';
        break;
      case 'name':
        if (value.isEmpty) return 'Nome não pode estar vazio';
        if (value.length < 2) return 'Nome deve ter pelo menos 2 caracteres';
        break;
      case 'value':
        if (value.isEmpty) return 'Valor não pode estar vazio';
        if (double.tryParse(value) == null) return 'Valor deve ser um número válido';
        if (double.parse(value) <= 0) return 'Valor deve ser maior que zero';
        break;
      case 'date':
        if (value.isEmpty) return 'Data não pode estar vazia';
        try {
          DateTime.parse(value);
        } catch (e) {
          return 'Data deve estar em formato válido (YYYY-MM-DD)';
        }
        break;
    }
    return 'Campo inválido';
  }
}