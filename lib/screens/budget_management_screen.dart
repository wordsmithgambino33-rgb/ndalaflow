import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../services/firestore_service.dart';
import '../services/local_db.dart';
import '../models/transaction.dart' as model;

class BudgetManagementScreen extends StatefulWidget {
  const BudgetManagementScreen({Key? key}) : super(key: key);

  @override
  State<BudgetManagementScreen> createState() => _BudgetManagementScreenState();
}

class _BudgetManagementScreenState extends State<BudgetManagementScreen> {
  void _openFinancialLibrary() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FinancialLiteracyLibrary(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Budget Management'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('Your Budget Overview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text('Track your income, expenses, and savings goals while accessing financial tips.', style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _openFinancialLibrary,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        minimumSize: const Size.fromHeight(48),
                      ),
                      child: const Text('Open Financial Literacy Library'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Transactions: use Firestore stream when online, fallback to local SQLite when offline.
            Expanded(child: _transactionsSection()),
          ],
        ),
      ),
    );
  }

  // New: choose data source and render
  Widget _transactionsSection() {
    return FutureBuilder<ConnectivityResult>(
      future: Connectivity().checkConnectivity(),
      builder: (context, connSnap) {
        if (connSnap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final isOnline = connSnap.data != ConnectivityResult.none;
        if (isOnline) {
          // Online -> Firestore (StreamBuilder)
          return StreamBuilder<List<model.Transaction>>(
            stream: FirestoreService.instance.transactionsStream(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final items = snap.data ?? [];
              if (items.isEmpty) {
                return _emptyTransactionsWidget(isOnline: true);
              }
              return ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, i) => _transactionTile(items[i], online: true),
              );
            },
          );
        } else {
          // Offline -> SQLite (FutureBuilder)
          return FutureBuilder<List<model.Transaction>>(
            future: LocalDatabase.instance.getAllTransactions(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final items = snap.data ?? [];
              if (items.isEmpty) {
                return _emptyTransactionsWidget(isOnline: false);
              }
              return ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, i) => _transactionTile(items[i], online: false),
              );
            },
          );
        }
      },
    );
  }

  Widget _transactionTile(model.Transaction tx, {required bool online}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: tx.type == 'income' ? Colors.green : Colors.red,
          child: Icon(tx.type == 'income' ? Icons.arrow_downward : Icons.arrow_upward, color: Colors.white, size: 18),
        ),
        title: Text('${tx.category} • ${tx.amount.toStringAsFixed(0)} MWK'),
        subtitle: Text(tx.note ?? '', maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${tx.date.year}-${tx.date.month.toString().padLeft(2, '0')}-${tx.date.day.toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Icon(online ? Icons.cloud_done : Icons.cloud_off, size: 16, color: online ? Colors.green : Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _emptyTransactionsWidget({required bool isOnline}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isOnline ? Icons.cloud_queue : Icons.save_alt, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(isOnline ? 'No transactions in cloud yet.' : 'No local transactions found.', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                // Quick example: add a sample transaction locally (for demo)
                final now = DateTime.now();
                final sample = model.Transaction(
                  id: now.millisecondsSinceEpoch.toString(),
                  type: 'expense',
                  category: 'Sample',
                  amount: 1000.0,
                  note: 'Demo transaction',
                  date: now,
                );
                if (isOnline) {
                  FirestoreService.instance.addTransaction(sample);
                } else {
                  LocalDatabase.instance.upsertTransaction(sample);
                  setState(() {});
                }
              },
              child: const Text('Add sample transaction'),
            ),
          ],
        ),
      ),
    );
  }
}

class FinancialLiteracyLibrary extends StatelessWidget {
  const FinancialLiteracyLibrary({Key? key}) : super(key: key);

  final List<Map<String, String>> topics = const [
    {
      'title': 'Budgeting Basics',
      'content': '''
What is a budget?
A budget is a simple plan that shows how much money you expect to earn (income) and how much you plan to spend (expenses). It helps you control your money instead of money controlling you.

Practical method — 50/30/20 rule:
- 50% Needs: rent, food, utilities, transport.
- 30% Wants: entertainment, dining out, extras.
- 20% Savings & Debt repayment.

Example:
If your monthly income is MWK 450,000:
- Needs (50%) = MWK 225,000
- Wants (30%) = MWK 135,000
- Savings/Debt (20%) = MWK 90,000

How to start:
1. Track your spending for one month (write down or use an app).
2. Group items into Needs/Wants/Savings.
3. Adjust slowly — move nonessential spending into 'Wants' before cutting essentials.
4. Review monthly and update categories as income or obligations change.
''',
    },
    {
      'title': 'Saving Money',
      'content': '''
Why save?
Savings give you a safety net (emergency fund), allow you to reach short-term goals, and provide capital for investments.

Emergency fund:
Aim to build 3–6 months of basic expenses. If your monthly needs are MWK 100,000, target MWK 300,000–600,000.

Start small — consistency matters:
Example: MWK 500 per week → MWK 2,000 per month → MWK 24,000 per year.
Increasing to MWK 5,000 per week gets you MWK 260,000 per year.

Tips to increase savings:
- Automate transfers to a savings account right after payday.
- Treat savings as a fixed expense.
- Reduce one recurring cost (e.g., a subscription) and move that amount to savings.

Where to keep savings:
- Immediate emergency fund: easy-access savings account.
- Medium-term: fixed deposits or high-yield savings offering better rates.
''',
    },
    {
      'title': 'Investment Basics',
      'content': '''
What is investment?
Putting money into an asset today with the expectation it will grow over time (generate returns).

Common options:
- Savings accounts & fixed deposits: low risk, low return — good for short/medium-term safety.
- Government securities (Treasury bills): low–medium risk, predictable returns.
- Unit trusts / mutual funds: pooled investments managed by professionals.
- Stocks: ownership in companies — higher potential returns and higher risk.
- Property: can provide rental income and capital growth.

Risk vs return:
Higher expected returns usually come with higher risk. Match investments to your goals and time horizon.

Simple example — compound interest:
If MWK 100,000 grows at 8% yearly, after 5 years it becomes approx. MWK 146,900 (compounding).

Diversification:
Spread money across different assets to reduce the effect of any single investment performing poorly.
''',
    },
    {
      'title': 'Assets vs Liabilities',
      'content': '''
Definitions:
- Asset: something that puts money into your pocket (cash, investments, rental property).
- Liability: something that takes money out (loans, credit card debt).

Examples:
- Asset: a rental house that generates MWK 20,000/month.
- Liability: a car loan that requires monthly payments.

A home can be both:
- If you live in a house it may be a liability (maintenance, mortgage payments).
- If you rent it out and it produces positive cash flow it is an asset.

Why it matters:
Focus on building assets that produce income and be careful accumulating liabilities that drain cash.
''',
    },
    {
      'title': 'Managing Debt (smartly)',
      'content': '''
Types of debt:
- Good debt: used to buy appreciating assets or investments (e.g., student loan with higher future earnings).
- Bad debt: high-interest consumer debt (credit cards, payday loans).

Interest example:
If you borrow MWK 100,000 at 20% annual interest, interest alone can add MWK 20,000 per year. Reducing interest saves money.

Repayment strategies:
- Debt Snowball: pay off smallest balances first (motivational wins).
- Debt Avalanche: pay off highest interest debts first (saves most interest).

Practical steps:
1. Always pay at least the minimum.
2. Prioritize high-interest debt for extra payments.
3. Consider consolidating expensive debt into lower-interest options if available.
''',
    },
    {
      'title': 'Retirement & Long‑Term Planning',
      'content': '''
Why plan early:
Small regular contributions grow by compounding over decades.

Rule of thumb:
Aim to save 10–20% of your income for retirement if possible.

Simple projection:
If you save MWK 5,000 monthly and earn a 6% annual return, in 30 years you may have over MWK 1.5 million (compounded growth).

Steps:
- Start a retirement account or pension.
- Increase contributions gradually (e.g., after a raise).
- Move investments toward lower volatility as you near retirement.
''',
    },
    {
      'title': 'Insurance Essentials',
      'content': '''
Purpose:
Insurance protects you and your family from big, unexpected financial losses.

Common types:
- Health insurance: covers medical bills.
- Life insurance: replaces income for dependents if you pass away.
- Asset insurance: protects property (home, vehicle).

Example: Health shock
A major medical bill without insurance can quickly erase savings and push you into debt — insurance transfers this risk to a provider for a predictable premium.
''',
    },
    {
      'title': 'Credit Score & Financial Reputation',
      'content': '''
What is a credit score?
A numerical summary of your credit history that lenders use to decide risk.

What affects it:
- Payment history (on-time payments help).
- Credit utilization (keep balances low relative to limits).
- Length of credit history and types of credit.

Why it matters:
Better scores lead to lower interest rates, cheaper loans, and easier access to credit.
Check your score and correct any errors on reports.
''',
    },
    {
      'title': 'Setting SMART Financial Goals',
      'content': '''
SMART goals: Specific, Measurable, Achievable, Relevant, Time-bound.

Examples:
- Short-term: Save MWK 100,000 in 6 months for a phone.
- Mid-term: Build an emergency fund of MWK 600,000 in 18 months.
- Long-term: Save MWK 5,000,000 for a home deposit in 5 years.

Break goals into monthly targets to make them actionable and track progress regularly.
''',
    },
    {
      'title': 'Simple Monthly Budget Template',
      'content': '''
A basic template to copy:
1. Income:
   - Salary: MWK _______
   - Other income: MWK _______
   Total income: MWK _______

2. Fixed Needs:
   - Rent/mortgage: MWK _______
   - Utilities: MWK _______
   - School fees: MWK _______
   Total fixed: MWK _______

3. Variable Needs:
   - Groceries: MWK _______
   - Transport: MWK _______
   Total variable: MWK _______

4. Wants:
   - Eating out: MWK _______
   - Subscriptions: MWK _______
   Total wants: MWK _______

5. Savings & Debt:
   - Emergency fund: MWK _______
   - Debt repayment: MWK _______
   Total saved/repaid: MWK _______

Action:
- Subtract expenses from income. If positive, increase savings/repayment; if negative, reduce wants or negotiate fixed costs.
''',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: ListView.builder(
            controller: scrollController,
            itemCount: topics.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
                      const SizedBox(width: 8),
                      const Text('Financial Literacy Library', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                );
              }
              final topic = topics[index - 1];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  title: Text(topic['title']!),
                  subtitle: Text(topic['content']!),
                  leading: const Icon(Icons.book),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
