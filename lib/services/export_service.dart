import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import '../models/bank_slip.dart';
import '../models/budget.dart';
import '../models/monthly_budget.dart';
import '../models/category.dart';

class ExportService {
  static final ExportService _instance = ExportService._internal();
  factory ExportService() => _instance;
  ExportService._internal();

  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  final DateFormat _monthFormat = DateFormat('MM/yyyy');
  final NumberFormat _currencyFormat = NumberFormat.currency(
    symbol: 'R\$ ',
    decimalDigits: 2,
  );

  // Exportar para PDF
  Future<String> exportToPDF({
    required Budget budget,
    required List<MonthlyBudget> monthlyBudgets,
    required List<BankSlip> bankSlips,
    required List<Category> categories,
    String? title,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final pdf = pw.Document();
      
      // Capa
      pdf.addPage(
        pw.Page(
          build: (context) => _buildCoverPage(
            title: title ?? 'Relatório Financeiro',
            dateRange: _getDateRangeText(startDate, endDate),
            budget: budget,
          ),
        ),
      );

      // Resumo Executivo
      pdf.addPage(
        pw.Page(
          build: (context) => _buildExecutiveSummary(
            budget: budget,
            monthlyBudgets: monthlyBudgets,
            bankSlips: bankSlips,
            categories: categories,
          ),
        ),
      );

      // Despesas por Categoria
      pdf.addPage(
        pw.Page(
          build: (context) => _buildCategoryBreakdown(
            bankSlips: bankSlips,
            categories: categories,
          ),
        ),
      );

      // Detalhes das Transações
      if (bankSlips.isNotEmpty) {
        pdf.addPage(
          pw.Page(
            build: (context) => _buildTransactionDetails(
              bankSlips: bankSlips,
              categories: categories,
            ),
          ),
        );
      }

      // Análise Mensal
      if (monthlyBudgets.isNotEmpty) {
        pdf.addPage(
          pw.Page(
            build: (context) => _buildMonthlyAnalysis(
              monthlyBudgets: monthlyBudgets,
              bankSlips: bankSlips,
            ),
          ),
        );
      }

      // Salvar arquivo
      final output = await getTemporaryDirectory();
      final file = File("${output.path}/relatorio_financeiro_${DateTime.now().millisecondsSinceEpoch}.pdf");
      await file.writeAsBytes(await pdf.save());
      
      return file.path;
    } catch (e) {
      throw Exception('Erro ao exportar PDF: $e');
    }
  }

  // Exportar para Excel
  Future<String> exportToExcel({
    required Budget budget,
    required List<MonthlyBudget> monthlyBudgets,
    required List<BankSlip> bankSlips,
    required List<Category> categories,
    String? title,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final excel = Excel.createExcel();
      
      // Configurar planilhas
      final summarySheet = excel['Resumo'];
      final transactionsSheet = excel['Transações'];
      final categoriesSheet = excel['Categorias'];
      final monthlySheet = excel['Análise Mensal'];

      // Preencher Resumo
      _fillSummarySheet(summarySheet, budget, monthlyBudgets, bankSlips, startDate, endDate);
      
      // Preencher Transações
      _fillTransactionsSheet(transactionsSheet, bankSlips, categories);
      
      // Preencher Categorias
      _fillCategoriesSheet(categoriesSheet, categories, bankSlips);
      
      // Preencher Análise Mensal
      _fillMonthlySheet(monthlySheet, monthlyBudgets, bankSlips);

      // Salvar arquivo
      final output = await getTemporaryDirectory();
      final file = File("${output.path}/relatorio_financeiro_${DateTime.now().millisecondsSinceEpoch}.xlsx");
      await file.writeAsBytes(excel.encode()!);
      
      return file.path;
    } catch (e) {
      throw Exception('Erro ao exportar Excel: $e');
    }
  }

  // Compartilhar arquivo
  Future<void> shareFile(String filePath, {String? subject, String? text}) async {
    try {
      final file = XFile(filePath);
      await Share.shareXFiles(
        [file],
        subject: subject ?? 'Relatório Financeiro',
        text: text ?? 'Segue meu relatório financeiro',
      );
    } catch (e) {
      throw Exception('Erro ao compartilhar: $e');
    }
  }

  // Métodos privados para construir PDF
  pw.Widget _buildCoverPage({
    required String title,
    required String dateRange,
    required Budget budget,
  }) {
    return pw.Column(
      mainAxisAlignment: pw.MainAxisAlignment.center,
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: 32,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue,
          ),
        ),
        pw.SizedBox(height: 20),
        pw.Text(
          dateRange,
          style: pw.TextStyle(fontSize: 16, color: PdfColors.grey),
        ),
        pw.SizedBox(height: 40),
        pw.Container(
          padding: const pw.EdgeInsets.all(20),
          decoration: pw.BoxDecoration(
            color: PdfColors.blue50,
            borderRadius: pw.BorderRadius.circular(10),
          ),
          child: pw.Column(
            children: [
              pw.Text(
                'Resumo Financeiro',
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text('Salário: ${_currencyFormat.format(budget.salary ?? 0)}'),
              pw.Text('Gastos Totais: ${_currencyFormat.format(budget.getGasto())}'),
              pw.Text('Economizado: ${_currencyFormat.format(budget.getPoupado())}'),
              pw.Text('Média de Gastos: ${_currencyFormat.format(budget.getMedia())}'),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _buildExecutiveSummary({
    required Budget budget,
    required List<MonthlyBudget> monthlyBudgets,
    required List<BankSlip> bankSlips,
    required List<Category> categories,
  }) {
    final totalExpenses = budget.getGasto();
    final savings = budget.getPoupado();
    final savingsRate = budget.salary != null && budget.salary! > 0 
        ? (savings / budget.salary!) * 100 
        : 0;

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Resumo Executivo',
          style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 20),
        _buildSummaryCard('Visão Geral', [
          'Total de Gastos: ${_currencyFormat.format(totalExpenses)}',
          'Economia: ${_currencyFormat.format(savings)}',
          'Taxa de Economia: ${savingsRate.toStringAsFixed(1)}%',
          'Número de Transações: ${bankSlips.length}',
        ]),
        pw.SizedBox(height: 20),
        _buildSummaryCard('Análise por Categoria', 
          categories.map((category) {
            final categoryExpenses = _getCategoryExpenses(category.id!, bankSlips);
            return '${category.name}: ${_currencyFormat.format(categoryExpenses)}';
          }).toList(),
        ),
      ],
    );
  }

  pw.Widget _buildSummaryCard(String title, List<String> items) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 10),
          ...items.map((item) => pw.Padding(
            padding: const pw.EdgeInsets.only(left: 10, bottom: 5),
            child: pw.Text('• $item'),
          )),
        ],
      ),
    );
  }

  pw.Widget _buildCategoryBreakdown({
    required List<BankSlip> bankSlips,
    required List<Category> categories,
  }) {
    final categoryTotals = <int, double>{};
    
    for (final slip in bankSlips) {
      if (slip.categoryId != null) {
        categoryTotals[slip.categoryId!] = 
            (categoryTotals[slip.categoryId!] ?? 0) + (slip.value ?? 0);
      }
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Despesas por Categoria',
          style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 20),
        ...categories.where((cat) => categoryTotals.containsKey(cat.id)).map((category) {
          final total = categoryTotals[category.id] ?? 0;
          final percentage = bankSlips.isNotEmpty 
              ? (total / bankSlips.fold(0.0, (sum, slip) => sum + (slip.value ?? 0))) * 100 
              : 0;
              
          return pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 15),
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey100,
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Row(
              children: [
                pw.Expanded(
                  flex: 3,
                  child: pw.Text(
                    category.name,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.Expanded(
                  flex: 2,
                  child: pw.Text(_currencyFormat.format(total)),
                ),
                pw.Expanded(
                  flex: 1,
                  child: pw.Text('${percentage.toStringAsFixed(1)}%'),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  pw.Widget _buildTransactionDetails({
    required List<BankSlip> bankSlips,
    required List<Category> categories,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Detalhes das Transações',
          style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 20),
        pw.Table(
          border: pw.TableBorder.all(),
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey300),
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('Data', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('Descrição', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('Categoria', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text('Valor', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
              ],
            ),
            ...bankSlips.map((slip) => pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(slip.date ?? ''),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(slip.name ?? ''),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(_getCategoryName(slip.categoryId, categories)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(_currencyFormat.format(slip.value ?? 0)),
                ),
              ],
            )),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildMonthlyAnalysis({
    required List<MonthlyBudget> monthlyBudgets,
    required List<BankSlip> bankSlips,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Análise Mensal',
          style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 20),
        ...monthlyBudgets.map((monthly) {
          final monthExpenses = bankSlips
              .where((slip) => slip.date?.contains('${monthly.month}/${monthly.year}') ?? false)
              .fold(0.0, (sum, slip) => sum + (slip.value ?? 0));
              
          return pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 15),
            padding: const pw.EdgeInsets.all(15),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey400),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  '${monthly.month}/${monthly.year}',
                  style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 10),
                pw.Text('Orçamento: ${_currencyFormat.format(monthly.obterTotal())}'),
                pw.Text('Gastos: ${_currencyFormat.format(monthExpenses)}'),
                pw.Text('Economia: ${_currencyFormat.format(monthly.obterTotal() - monthExpenses)}'),
              ],
            ),
          );
        }),
      ],
    );
  }

  // Métodos auxiliares
  String _getDateRangeText(DateTime? startDate, DateTime? endDate) {
    if (startDate == null || endDate == null) {
      return 'Período: Todo o histórico';
    }
    return 'Período: ${_dateFormat.format(startDate)} a ${_dateFormat.format(endDate)}';
  }

  double _getCategoryExpenses(int categoryId, List<BankSlip> bankSlips) {
    return bankSlips
        .where((slip) => slip.categoryId == categoryId)
        .fold(0.0, (sum, slip) => sum + (slip.value ?? 0));
  }

  String _getCategoryName(int? categoryId, List<Category> categories) {
    if (categoryId == null || categoryId == 0) return 'Sem categoria';
    final category = categories.firstWhere(
      (cat) => cat.id == categoryId,
      orElse: () => categories.last,
    );
    return category.name;
  }

  // Métodos para Excel
  void _fillSummarySheet(
    Sheet sheet,
    Budget budget,
    List<MonthlyBudget> monthlyBudgets,
    List<BankSlip> bankSlips,
    DateTime? startDate,
    DateTime? endDate,
  ) {
    final totalExpenses = budget.getGasto();
    final savings = budget.getPoupado();
    final savingsRate = budget.salary != null && budget.salary! > 0 
        ? (savings / budget.salary!) * 100 
        : 0;

    // Cabeçalho
    sheet.merge(CellIndex.indexByString("A1"), CellIndex.indexByString("D1"));
    sheet.cell(CellIndex.indexByString("A1")).value = TextCellValue('RESUMO FINANCEIRO');
    sheet.cell(CellIndex.indexByString("A1")).cellStyle = CellStyle(
      fontSize: 16,
      bold: true,
      horizontalAlign: HorizontalAlign.Center,
    );

    // Dados principais
    int row = 3;
    sheet.cell(CellIndex.indexByString("A$row")).value = TextCellValue('Salário:');
      sheet.cell(CellIndex.indexByString("B$row")).value = TextCellValue((budget.salary ?? 0).toStringAsFixed(2));
      sheet.cell(CellIndex.indexByString("B$row")).cellStyle = CellStyle();
    
    row++;
    sheet.cell(CellIndex.indexByString("A$row")).value = TextCellValue('Total de Gastos:');
      sheet.cell(CellIndex.indexByString("B$row")).value = TextCellValue(totalExpenses.toStringAsFixed(2));
      sheet.cell(CellIndex.indexByString("B$row")).cellStyle = CellStyle();
    
    row++;
    sheet.cell(CellIndex.indexByString("A$row")).value = TextCellValue('Economia:');
      sheet.cell(CellIndex.indexByString("B$row")).value = TextCellValue(savings.toStringAsFixed(2));
      sheet.cell(CellIndex.indexByString("B$row")).cellStyle = CellStyle();
    
    row++;
    sheet.cell(CellIndex.indexByString("A$row")).value = TextCellValue('Taxa de Economia:');
      sheet.cell(CellIndex.indexByString("B$row")).value = TextCellValue('${savingsRate.toStringAsFixed(1)}%');
    
    row++;
    sheet.cell(CellIndex.indexByString("A$row")).value = TextCellValue('Número de Transações:');
      sheet.cell(CellIndex.indexByString("B$row")).value = TextCellValue(bankSlips.length.toString());
  }

  void _fillTransactionsSheet(
    Sheet sheet,
    List<BankSlip> bankSlips,
    List<Category> categories,
  ) {
    // Cabeçalho
    sheet.cell(CellIndex.indexByString("A1")).value = TextCellValue('Data');
    sheet.cell(CellIndex.indexByString("B1")).value = TextCellValue('Descrição');
    sheet.cell(CellIndex.indexByString("C1")).value = TextCellValue('Categoria');
    sheet.cell(CellIndex.indexByString("D1")).value = TextCellValue('Valor');
    sheet.cell(CellIndex.indexByString("E1")).value = TextCellValue('Descrição Detalhada');
    sheet.cell(CellIndex.indexByString("F1")).value = TextCellValue('Tags');

    // Estilo do cabeçalho
    final headerStyle = CellStyle(
      bold: true,
      horizontalAlign: HorizontalAlign.Center,
    );
    
    for (var col = 0; col < 6; col++) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0)).cellStyle = headerStyle;
    }

    // Dados
    for (int i = 0; i < bankSlips.length; i++) {
      final slip = bankSlips[i];
      final row = i + 2;
      
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row)).value = TextCellValue(slip.date ?? '');
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row)).value = TextCellValue(slip.name ?? '');
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row)).value = 
          TextCellValue(_getCategoryName(slip.categoryId, categories));
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row)).value = TextCellValue((slip.value ?? 0).toStringAsFixed(2));
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row)).cellStyle = CellStyle();
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row)).value = TextCellValue(slip.description ?? '');
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: row)).value = TextCellValue(slip.tags ?? '');
    }
  }

  void _fillCategoriesSheet(
    Sheet sheet,
    List<Category> categories,
    List<BankSlip> bankSlips,
  ) {
    // Cabeçalho
    sheet.cell(CellIndex.indexByString("A1")).value = TextCellValue('Categoria');
    sheet.cell(CellIndex.indexByString("B1")).value = TextCellValue('Total Gasto');
    sheet.cell(CellIndex.indexByString("C1")).value = TextCellValue('Orçamento');
    sheet.cell(CellIndex.indexByString("D1")).value = TextCellValue('% Utilizado');
    sheet.cell(CellIndex.indexByString("E1")).value = TextCellValue('Status');

    // Estilo do cabeçalho
    final headerStyle = CellStyle(
      bold: true,
      horizontalAlign: HorizontalAlign.Center,
    );
    
    for (var col = 0; col < 5; col++) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0)).cellStyle = headerStyle;
    }

    // Dados
    for (int i = 0; i < categories.length; i++) {
      final category = categories[i];
      final expenses = _getCategoryExpenses(category.id!, bankSlips);
      final percentage = category.budgetLimit > 0 
          ? (expenses / category.budgetLimit) * 100 
          : 0;
      final row = i + 2;
      
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row)).value = TextCellValue(category.name);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row)).value = TextCellValue(expenses.toStringAsFixed(2));
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row)).value = TextCellValue(category.budgetLimit.toStringAsFixed(2));
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row)).value = TextCellValue('${percentage.toStringAsFixed(1)}%');
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row)).value = 
          TextCellValue(percentage > 100 ? 'Estourado' : percentage > 80 ? 'Alerta' : 'OK');
    }
  }

  void _fillMonthlySheet(
    Sheet sheet,
    List<MonthlyBudget> monthlyBudgets,
    List<BankSlip> bankSlips,
  ) {
    // Cabeçalho
    sheet.cell(CellIndex.indexByString("A1")).value = TextCellValue('Mês/Ano');
    sheet.cell(CellIndex.indexByString("B1")).value = TextCellValue('Orçamento');
    sheet.cell(CellIndex.indexByString("C1")).value = TextCellValue('Gastos');
    sheet.cell(CellIndex.indexByString("D1")).value = TextCellValue('Economia');
    sheet.cell(CellIndex.indexByString("E1")).value = TextCellValue('% Utilizado');

    // Estilo do cabeçalho
    final headerStyle = CellStyle(
      bold: true,
      horizontalAlign: HorizontalAlign.Center,
    );
    
    for (var col = 0; col < 5; col++) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0))
        ..cellStyle = headerStyle;
    }

    // Dados
    for (int i = 0; i < monthlyBudgets.length; i++) {
      final monthly = monthlyBudgets[i];
      final monthExpenses = bankSlips
          .where((slip) => slip.date?.contains('${monthly.month}/${monthly.year}') ?? false)
          .fold(0.0, (sum, slip) => sum + (slip.value ?? 0));
      final savings = monthly.obterTotal() - monthExpenses;
      final percentage = monthly.obterTotal() > 0 
          ? (monthExpenses / monthly.obterTotal()) * 100 
          : 0;
      final row = i + 2;
      
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row)).value = TextCellValue('${monthly.month}/${monthly.year}');
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row)).value = TextCellValue(monthly.obterTotal().toStringAsFixed(2));
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row)).cellStyle = CellStyle();
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row)).value = TextCellValue(monthExpenses.toStringAsFixed(2));
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row)).cellStyle = CellStyle();
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row)).value = TextCellValue(savings.toStringAsFixed(2));
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row)).cellStyle = CellStyle();
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row)).value = TextCellValue('${percentage.toStringAsFixed(1)}%');
    }
  }
}