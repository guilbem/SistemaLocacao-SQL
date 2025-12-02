

# ✅ BANCO DE DADOS RELACIONAL – Sistema de Locação de Veículos - SQL

---

# 📌 **1. Descrição do Domínio**

O Sistema de Locação de Veículos tem como objetivo gerenciar todo o ciclo operacional de uma locadora, desde o cadastro de clientes e veículos até reservas, locações, devoluções, cobranças e controle de movimentação da frota. O modelo proposto simula processos reais de empresas do setor, incluindo controle de filiais, categorias, tarifas, taxas, pagamentos e manutenção de veículos.

A solução foi desenvolvida com foco na rastreabilidade das operações, consistência das informações e flexibilidade para consultas gerenciais. Cada etapa do fluxo — reserva → retirada → uso → devolução → pagamento — é representada por tabelas e relacionamentos adequados, permitindo registros completos e análises de desempenho, faturamento e disponibilidade de frota.

Além das operações básicas, o projeto integra controles complementares, como histórico de movimentações, auditoria via triggers, índices otimizados, visões para relatórios mensais e uma procedure para *devolução automatizada* utilizando function de cálculo de multa.

---

# ⚙️ **2. Como Executar os Scripts (Ordem Recomendada)**

Execute os arquivos **nesta ordem**:

1️⃣ **01_create_database.sql**
→ Cria o banco LOCADORA e todas as tabelas com suas PKs, FKs e constraints.

2️⃣ **02_alteracoes_evolucao_esquema.sql**
→ Inclui ALTER TABLE, TRUNCATE, DROP VIEW e recriação de view.

3️⃣ **03_inserts_dados_minimos.sql**
→ Adiciona clientes, filiais, categorias, veículos, reservas e locações.

4️⃣ **04_updates_deletes.sql**
→ Registra correções de cadastro, cancelamentos, ajustes e exclusões controladas.

5️⃣ **05_queries_select.sql**
→ Contém consultas obrigatórias: JOINs, agregações, CASE, GROUP BY, subconsultas e validações.

6️⃣ **06_views.sql**
→ Criação das views:

* `vw_faturamento_mensal`
* `vw_utilizacao_frota`
* `vw_clientes`

7️⃣ **07_functions_procedures.sql**
→ Function `calcular_multa_atraso()`
→ Procedure `registrar_devolucao()`

8️⃣ **BONUS.sql**
→ Índices, triggers de auditoria e constraints adicionais.

---

# 🛠️ **3. Dependências e Configurações**

* **MySQL 8.x ou superior**
  (necessário por causa de CHECK CONSTRAINT e melhorias em procedures)
* Configuração recomendada:

  * `sql_safe_updates = 1` (ativado)
  * ENGINE padrão: **InnoDB**
  * `LOCAL_TIME_ZONE = '-03:00'` (opcional para DATETIME)

Não exige nenhuma extensão adicional.

---

# 📚 **4. Glossário de Tabelas**

### **CLIENTE**

Cadastro básico do cliente: nome, CPF, telefone, e status (ativo/inativo).

### **FILIAL**

Unidades da empresa. Contém endereço, cidade, UF e horários.

### **FUNCIONARIO**

Funcionários vinculados à filial. Armazena cargo, datas e status.

### **CATEGORIA**

Classificação dos veículos (econômico, padrão, luxo).

### **VEICULO**

Dados completos da frota: placa, renavam, categoria, filial e status operacional.

### **RESERVA**

Registro da intenção de uso: cliente + veículo + período previsto.

### **LOCACAO**

A locação efetivada: datas, controle de KM, valores e status.

### **TARIFA**

Tarifas válidas por categoria e período de vigência.

### **TAXA**

Taxas adicionais aplicadas por filial (valor fixo ou percentual).

### **PAGAMENTO**

Pagamentos das locações: método, valor e status.

### **MOVIMENTO_VEICULO**

Histórico de movimentações operacionais da frota.

### **MANUTENCAO**

Entradas de manutenção preventiva ou corretiva.

---

# 🧩 **5. Decisões de Modelagem**

### **✔ Separação entre RESERVA e LOCACAO**

A reserva representa apenas a *intenção* de usar o veículo, enquanto a locação é o *uso real*.
Isso permite:

* cancelar reservas sem apagar histórico
* medir taxa de conversão
* controlar veículos bloqueados por reserva futura

### **✔ Controle de Filiais**

Veículos pertencem a uma filial, mas podem ser movimentados (tabela MOVIMENTO_VEICULO).
Isso reflete cenários reais como:

* transferência entre unidades
* devolução em filial diferente

### **✔ Tarifas x Taxas**

Tarifas são valores de diária.
Taxas são adicionais por serviço (limpeza, entrega, etc).
Modelados separadamente para permitir combinações flexíveis.

### **✔ Status estruturados (ENUMs)**

Campos como STATUSVEICULO e STATUSLOCACAO usam ENUMs para garantir consistência.

### **✔ Procedure de devolução + Function de multa**

Simula operação real de caixa:

* calcula atraso
* aplica multa
* fecha locação
* atualiza KM
* libera veículo

### **✔ Views para relatórios**

* `vw_faturamento_mensal` → análises gerenciais
* `vw_utilizacao_frota` → performance da frota
* `vw_clientes` → listagem geral para CRM

### **✔ Índices estratégicos**

Criados em campos altamente consultados:
datas, filiais, categorias e vínculos.

---

#**Autor:** Guilherme Ferreira Pinheiro Guimarães
#**Disciplina:** Banco de Dados 2 – Projeto Final
**BANCO DE DADOS RELACIONAL – Sistema de Locação de Veículos - MYSQL**

---
---

