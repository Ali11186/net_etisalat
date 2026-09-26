import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import 'login_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final user = userProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Net Etisalat',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          if (user.loggedIn)
            IconButton(
              tooltip: 'تسجيل الخروج',
              onPressed: () async {
                await context.read<UserProvider>().logout();

                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم تسجيل الخروج'),
                  ),
                );
              },
              icon: const Icon(Icons.logout_rounded),
            )
          else
            IconButton(
              tooltip: 'تسجيل الدخول',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.login_rounded),
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF0D2417),
                      Color(0xFF10251A),
                    ],
                  ),
                  border: Border.all(
                    color: Color(0xFF1E6B3A),
                  ),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.account_balance_wallet_rounded,
                      size: 52,
                      color: Color(0xFF00E676),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'رصيد الكوينز',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${user.balance}',
                      style: const TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'كوينز',
                      style: TextStyle(
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              if (user.loggedIn)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFF11161D),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: const Color(0xFF1E6B3A),
                    ),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Color(0xFF00C853),
                        child: Icon(
                          Icons.person_rounded,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'الحساب المسجل',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user.phone,
                              textDirection: TextDirection.ltr,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.verified_rounded,
                        color: Color(0xFF00E676),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 20),

              _ActionCard(
                icon: Icons.account_balance_wallet_rounded,
                title: 'معرفة الكوينز',
                subtitle: 'عرض رصيدك الحالي',
                onTap: () {},
              ),

              _ActionCard(
                icon: Icons.history_rounded,
                title: 'السجل',
                subtitle: 'عرض سجل الحساب',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HistoryScreen(),
                    ),
                  );
                },
              ),

              _ActionCard(
                icon: Icons.card_giftcard_rounded,
                title: 'الباقات',
                subtitle: 'عرض الباقات المتاحة',
                onTap: () {},
              ),

              if (!user.loggedIn) ...[
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.login_rounded),
                    label: const Text('تسجيل الدخول'),
                  ),
                ),
              ],

              const SizedBox(height: 20),

              const Text(
                'Net Etisalat',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: const Color(0xFF11161D),
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00C853)
                        .withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFF00E676),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.white38,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
