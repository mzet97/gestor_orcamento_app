import 'package:flutter/material.dart';
import 'package:zet_gestor_orcamento/database/isar_database.dart';
import 'package:zet_gestor_orcamento/models/bank_slip.dart';
import 'package:zet_gestor_orcamento/models/monthly_budget.dart';
import 'package:zet_gestor_orcamento/models/category.dart';

// Script de teste para verificar a funcionalidade de agendamentos
class TestAgendamentos {
  
  static Future<void> criarDadosTeste() async {
    try {
      print('🧪 Iniciando teste de agendamentos...');
      
      // 1. Criar categoria de teste
      final categoria = Category(
        id: 1,
        name: 'Alimentação',
        description: 'Categoria de teste',
        color: Colors.blue,
        icon: Icons.restaurant,
        budgetLimit: 500.0,
      );
      
      // 2. Criar orçamento mensal de teste
      final monthlyBudget = MonthlyBudget(
        id: 1,
        month: 'Janeiro',
        year: '2024',
      );
      
      // 3. Salvar orçamento mensal
      await IsarDatabase().saveMonthlyBudget(monthlyBudget);
      print('✅ Orçamento mensal criado: Janeiro/2024');
      
      // 4. Criar agendamentos de teste
      final agendamentos = [
        BankSlip(
          name: 'Supermercado',
          date: '2024-01-15',
          value: 150.50,
          categoryId: 1,
          description: 'Compras do mês',
          isPaid: false,
        ),
        BankSlip(
          name: 'Farmácia',
          date: '2024-01-20',
          value: 80.00,
          categoryId: 1,
          description: 'Medicamentos',
          isPaid: true,
        ),
        BankSlip(
          name: 'Restaurante',
          date: '2024-01-25',
          value: 120.00,
          categoryId: 1,
          description: 'Jantar especial',
          isPaid: false,
        ),
      ];
      
      // 5. Salvar agendamentos
      for (var agendamento in agendamentos) {
        await IsarDatabase().saveBankSlip(agendamento, 1);
        print('✅ Agendamento criado: ${agendamento.name} - R\$ ${agendamento.value}');
      }
      
      // 6. Verificar se os agendamentos foram salvos
      final agendamentosSalvos = await IsarDatabase().getAllBankSlip();
      print('📋 Total de agendamentos salvos: ${agendamentosSalvos.length}');
      
      for (var slip in agendamentosSalvos) {
        print('   - ${slip.name}: R\$ ${slip.value} | Data: ${slip.date} | Pago: ${slip.isPaid}');
      }
      
      print('🎉 Teste concluído com sucesso!');
      
    } catch (e) {
      print('❌ Erro no teste: $e');
    }
  }
  
  static Future<void> limparDadosTeste() async {
    try {
      print('🧹 Limpando dados de teste...');
      
      // Obter todos os agendamentos
      final agendamentos = await IsarDatabase().getAllBankSlip();
      
      // Deletar cada agendamento
      for (var agendamento in agendamentos) {
        await IsarDatabase().deleteBankSlipt(agendamento);
      }
      
      // Deletar orçamento mensal
      await IsarDatabase().deleteMonthlyBudget(MonthlyBudget(id: 1, month: 'Janeiro', year: '2024'));
      
      print('✅ Dados de teste limpos com sucesso!');
      
    } catch (e) {
      print('❌ Erro ao limpar dados: $e');
    }
  }
}