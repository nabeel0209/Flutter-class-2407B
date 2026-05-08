import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F3FF),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7C3AED),
          brightness: Brightness.light,
        ),
      ),
      home: const UserFormPage(),
    );
  }
}

// ─── Color Palette ─────────────────────────────────────
class AppColors {
  static const bg = Color(0xFFF5F3FF);
  static const surface = Color(0xFFFFFFFF);
  static const primary = Color(0xFF7C3AED);
  static const primaryLight = Color(0xFFEDE9FE);
  static const primaryMid = Color(0xFFDDD6FE);
  static const accent = Color(0xFFEC4899);
  static const accentLight = Color(0xFFFCE7F3);
  static const teal = Color(0xFF0D9488);
  static const tealLight = Color(0xFFCCFBF1);
  static const amber = Color(0xFFF59E0B);
  static const amberLight = Color(0xFFFEF3C7);
  static const red = Color(0xFFEF4444);
  static const redLight = Color(0xFFFEE2E2);
  static const textDark = Color(0xFF1E1B4B);
  static const textMid = Color(0xFF6B7280);
  static const textLight = Color(0xFF9CA3AF);
  static const border = Color(0xFFE9D5FF);
  static const shadow = Color(0x1A7C3AED);
}

// ─── Avatar Gradients ──────────────────────────────────
const List<List<Color>> avatarGradients = [
  [Color(0xFF7C3AED), Color(0xFFEC4899)],
  [Color(0xFF0D9488), Color(0xFF3B82F6)],
  [Color(0xFFF59E0B), Color(0xFFEF4444)],
  [Color(0xFF8B5CF6), Color(0xFF06B6D4)],
  [Color(0xFFEC4899), Color(0xFFF59E0B)],
  [Color(0xFF10B981), Color(0xFF7C3AED)],
];

// ─── Page ──────────────────────────────────────────────
class UserFormPage extends StatefulWidget {
  const UserFormPage({super.key});

  @override
  State<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage>
    with TickerProviderStateMixin {
  final _nameCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _nameFocus = FocusNode();
  final _ageFocus = FocusNode();

  final List<Map<String, dynamic>> users = [];
  late AnimationController _headerAnim;
  late Animation<double> _headerFade;

  @override
  void initState() {
    super.initState();
    _headerAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _headerFade = CurvedAnimation(parent: _headerAnim, curve: Curves.easeOut);
    _headerAnim.forward();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _ageCtrl.dispose();
    _nameFocus.dispose();
    _ageFocus.dispose();
    _headerAnim.dispose();
    super.dispose();
  }

  void addUser() {
    if (_nameCtrl.text
        .trim()
        .isEmpty || _ageCtrl.text
        .trim()
        .isEmpty) {
      _showToast(
        'Please fill in both fields',
        AppColors.red,
        Icons.warning_amber_rounded,
      );
      return;
    }
    setState(() {
      users.insert(0, {
        'name': _nameCtrl.text.trim(),
        'age': _ageCtrl.text.trim(),
        'id': DateTime
            .now()
            .millisecondsSinceEpoch,
      });
    });
    _nameCtrl.clear();
    _ageCtrl.clear();
    _nameFocus.unfocus();
    _ageFocus.unfocus();
    _showToast('User added!', AppColors.teal, Icons.check_circle_rounded);
  }

  void deleteUser(int index) {
    final name = users[index]['name'];
    setState(() => users.removeAt(index));
    _showToast('$name removed', AppColors.red, Icons.delete_rounded);
  }

  void editUser(int index) {
    final editName = TextEditingController(text: users[index]['name']);
    final editAge = TextEditingController(text: users[index]['age']);

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Edit',
      barrierColor: Colors.black38,
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (ctx, anim, _, child) {
        final curve = CurvedAnimation(parent: anim, curve: Curves.easeOutBack);
        return ScaleTransition(
          scale: curve,
          child: FadeTransition(opacity: anim, child: child),
        );
      },
      pageBuilder: (ctx, _, __) =>
          _EditDialog(
            nameCtrl: editName,
            ageCtrl: editAge,
            userName: users[index]['name'],
            gradientColors: avatarGradients[index % avatarGradients.length],
            onSave: () {
              if (editName.text
                  .trim()
                  .isNotEmpty &&
                  editAge.text
                      .trim()
                      .isNotEmpty) {
                setState(() {
                  users[index]['name'] = editName.text.trim();
                  users[index]['age'] = editAge.text.trim();
                });
                Navigator.pop(ctx);
                _showToast(
                    'Changes saved!', AppColors.primary, Icons.edit_rounded);
              }
            },
          ),
    );
  }

  void _showToast(String msg, Color color, IconData icon) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Text(
              msg,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        duration: const Duration(seconds: 2),
        elevation: 6,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: CustomScrollView(
        slivers: [
          // ── Fancy SliverAppBar ────────────────────────
          SliverAppBar(
            expandedHeight: 160,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: _AppBarHeader(
                fadeAnim: _headerFade,
                userCount: users.length,
              ),
            ),
          ),

          // ── Input Card ────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: _InputCard(
                nameCtrl: _nameCtrl,
                ageCtrl: _ageCtrl,
                nameFocus: _nameFocus,
                ageFocus: _ageFocus,
                onAdd: addUser,
              ),
            ),
          ),

          // ── Section Header ────────────────────────────
          if (users.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 10),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 16,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.accent],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'REGISTERED USERS',
                      style: TextStyle(
                        color: AppColors.textMid,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${users.length}',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // ── User List ─────────────────────────────────
          users.isEmpty
              ? SliverFillRemaining(child: _EmptyState())
              : SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) =>
                    _UserCard(
                      user: users[index],
                      index: index,
                      gradientColors:
                      avatarGradients[index % avatarGradients.length],
                      onEdit: () => editUser(index),
                      onDelete: () => deleteUser(index),
                    ),
                childCount: users.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── AppBar Header ─────────────────────────────────────
class _AppBarHeader extends StatelessWidget {
  final Animation<double> fadeAnim;
  final int userCount;

  const _AppBarHeader({required this.fadeAnim, required this.userCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF7C3AED), Color(0xFFA855F7), Color(0xFFEC4899)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.07),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: 40,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            top: 30,
            right: 80,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          SafeArea(
            child: FadeTransition(
              opacity: fadeAnim,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.people_alt_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'User Manager',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.3,
                              ),
                            ),
                            Text(
                              'Manage your team easily',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white30),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.group_rounded,
                                color: Colors.white,
                                size: 15,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '$userCount',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Input Card ────────────────────────────────────────
class _InputCard extends StatefulWidget {
  final TextEditingController nameCtrl, ageCtrl;
  final FocusNode nameFocus, ageFocus;
  final VoidCallback onAdd;

  const _InputCard({
    required this.nameCtrl,
    required this.ageCtrl,
    required this.nameFocus,
    required this.ageFocus,
    required this.onAdd,
  });

  @override
  State<_InputCard> createState() => _InputCardState();
}

class _InputCardState extends State<_InputCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.96,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  void _onTapAdd() async {
    await _pulse.reverse();
    await _pulse.forward();
    widget.onAdd();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.accent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.person_add_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Add New User',
                style: TextStyle(
                  color: AppColors.textDark,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: _StyledField(
                  controller: widget.nameCtrl,
                  focusNode: widget.nameFocus,
                  label: 'FULL NAME',
                  hint: 'e.g. Ahmed Khan',
                  icon: Icons.person_outline_rounded,
                  accentColor: AppColors.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 3,
                child: _StyledField(
                  controller: widget.ageCtrl,
                  focusNode: widget.ageFocus,
                  label: 'AGE',
                  hint: '25',
                  icon: Icons.cake_outlined,
                  accentColor: AppColors.accent,
                  isNumber: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AnimatedBuilder(
            animation: _pulse,
            builder: (context, child) =>
                Transform.scale(scale: _pulse.value, child: child),
            child: GestureDetector(
              onTap: _onTapAdd,
              child: Container(
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.primary,
                      Color(0xFFA855F7),
                      AppColors.accent,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_circle_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Add User',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Styled Field ──────────────────────────────────────
class _StyledField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String label, hint;
  final IconData icon;
  final Color accentColor;
  final bool isNumber;

  const _StyledField({
    required this.controller,
    required this.focusNode,
    required this.label,
    required this.hint,
    required this.icon,
    required this.accentColor,
    this.isNumber = false,
  });

  @override
  State<_StyledField> createState() => _StyledFieldState();
}

class _StyledFieldState extends State<_StyledField> {
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(() {
      if (mounted) setState(() => _focused = widget.focusNode.hasFocus);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            color: _focused ? widget.accentColor : AppColors.textMid,
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 6),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: _focused
                ? widget.accentColor.withOpacity(0.04)
                : AppColors.bg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _focused ? widget.accentColor : AppColors.border,
              width: _focused ? 1.8 : 1.2,
            ),
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            keyboardType: widget.isNumber
                ? TextInputType.number
                : TextInputType.name,
            style: const TextStyle(
              color: AppColors.textDark,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: const TextStyle(
                color: AppColors.textLight,
                fontSize: 13,
              ),
              prefixIcon: Icon(
                widget.icon,
                color: _focused ? widget.accentColor : AppColors.textLight,
                size: 18,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── User Card ─────────────────────────────────────────
class _UserCard extends StatefulWidget {
  final Map<String, dynamic> user;
  final int index;
  final List<Color> gradientColors;
  final VoidCallback onEdit, onDelete;

  const _UserCard({
    required this.user,
    required this.index,
    required this.gradientColors,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<_UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<_UserCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _anim;
  late Animation<Offset> _slide;
  late Animation<double> _fade;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _anim, curve: Curves.easeOutCubic));
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeOut);

    Future.delayed(Duration(milliseconds: widget.index * 60), () {
      if (mounted) _anim.forward();
    });
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final parts = widget.user['name'].trim().split(' ');
    final initials = parts
        .take(2)
        .map((e) => e.isNotEmpty ? e[0].toUpperCase() : '')
        .join();

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          child: AnimatedScale(
            scale: _pressed ? 0.97 : 1.0,
            duration: const Duration(milliseconds: 100),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: widget.gradientColors[0].withOpacity(0.10),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: widget.gradientColors[0].withOpacity(0.15),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    // Gradient Avatar
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: widget.gradientColors,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: widget.gradientColors[0].withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          initials,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Name + Age
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.user['name'],
                            style: const TextStyle(
                              color: AppColors.textDark,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: widget.gradientColors[0].withOpacity(
                                    0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.cake_outlined,
                                      size: 11,
                                      color: widget.gradientColors[0],
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${widget.user['age']} yrs',
                                      style: TextStyle(
                                        color: widget.gradientColors[0],
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '#${widget.index + 1}',
                                style: const TextStyle(
                                  color: AppColors.textLight,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Buttons
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _CardActionBtn(
                          icon: Icons.edit_rounded,
                          bg: AppColors.primaryLight,
                          fg: AppColors.primary,
                          onTap: widget.onEdit,
                        ),
                        const SizedBox(width: 8),
                        _CardActionBtn(
                          icon: Icons.delete_rounded,
                          bg: AppColors.redLight,
                          fg: AppColors.red,
                          onTap: widget.onDelete,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Card Action Button ────────────────────────────────
class _CardActionBtn extends StatefulWidget {
  final IconData icon;
  final Color bg, fg;
  final VoidCallback onTap;

  const _CardActionBtn({
    required this.icon,
    required this.bg,
    required this.fg,
    required this.onTap,
  });

  @override
  State<_CardActionBtn> createState() => _CardActionBtnState();
}

class _CardActionBtnState extends State<_CardActionBtn> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: _pressed ? widget.fg : widget.bg,
          borderRadius: BorderRadius.circular(11),
        ),
        child: Icon(
          widget.icon,
          color: _pressed ? Colors.white : widget.fg,
          size: 18,
        ),
      ),
    );
  }
}

// ─── Empty State ───────────────────────────────────────
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primaryLight, AppColors.accentLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.group_add_rounded,
              size: 40,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No users yet',
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add your first user above\nto get started!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textMid,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.arrow_upward_rounded,
                  color: AppColors.primary,
                  size: 16,
                ),
                SizedBox(width: 6),
                Text(
                  'Fill the form above',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Edit Dialog ───────────────────────────────────────
class _EditDialog extends StatelessWidget {
  final TextEditingController nameCtrl, ageCtrl;
  final String userName;
  final List<Color> gradientColors;
  final VoidCallback onSave;

  const _EditDialog({
    required this.nameCtrl,
    required this.ageCtrl,
    required this.userName,
    required this.gradientColors,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final parts = userName.trim().split(' ');
    final initials = parts
        .take(2)
        .map((e) => e.isNotEmpty ? e[0].toUpperCase() : '')
        .join();

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.15),
                blurRadius: 40,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Gradient header
              Container(
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            initials,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Edit User',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    _DialogField(
                      controller: nameCtrl,
                      label: 'FULL NAME',
                      hint: 'Enter name',
                      icon: Icons.person_outline_rounded,
                      accent: gradientColors[0],
                    ),
                    const SizedBox(height: 14),
                    _DialogField(
                      controller: ageCtrl,
                      label: 'AGE',
                      hint: 'Enter age',
                      icon: Icons.cake_outlined,
                      accent: gradientColors[1],
                      isNumber: true,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.textMid,
                              side: const BorderSide(color: AppColors.border),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: onSave,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: gradientColors[0],
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text(
                              'Save Changes',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Dialog Field ──────────────────────────────────────
class _DialogField extends StatelessWidget {
  final TextEditingController controller;
  final String label, hint;
  final IconData icon;
  final Color accent;
  final bool isNumber;

  const _DialogField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.accent,
    this.isNumber = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: accent,
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.name,
          style: const TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.textLight),
            prefixIcon: Icon(icon, color: accent, size: 18),
            filled: true,
            fillColor: AppColors.bg,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: accent.withOpacity(0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: accent.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: accent, width: 1.8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }
}
