import 'package:flutter/material.dart';
import '../model/models.dart';
import 'student/student_main_screen.dart';
import 'professor/professor_main_screen.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late TextEditingController _idController;
  late TextEditingController _pwController;
  late TextEditingController _nameController;

  bool _isSignUpMode = false;
  bool _obscurePassword = true;
  int _userTypeIndex = 0; // 0: 학생, 1: 교수

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController();
    _pwController = TextEditingController();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _idController.dispose();
    _pwController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _showNotice(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 2)),
    );
  }

  void _handleSubmit() {
    final id = _idController.text.trim();
    final pw = _pwController.text.trim();
    final name = _nameController.text.trim();

    if (_isSignUpMode) {
      if (name.isEmpty || id.isEmpty || pw.isEmpty) {
        _showNotice("모든 입력칸을 채워주세요.");
        return;
      }
      if (Student.list.any((u) => u.studentId == id)) {
        _showNotice("이미 존재하는 학번입니다.");
        return;
      }
      setState(() {
        Student.list.add(
          Student(
            studentId: id,
            deptCode: 'CSE',
            name: name,
            phone: '010-0000-0000',
            grade: 1,
            academicStatus: '재학',
            maxCredits: 18,
            password: pw,
          ),
        );
        _isSignUpMode = false;
      });
      _showNotice("회원가입이 완료되었습니다. 로그인해주세요.");
      _pwController.clear();
    } else {
      if (id.isEmpty || pw.isEmpty) {
        _showNotice("아이디와 비밀번호를 입력해주세요.");
        return;
      }

      if (_userTypeIndex == 0) {
        final matched = Student.list.where((s) => s.studentId == id && s.password == pw).toList();
        if (matched.isNotEmpty) {
          Student.current = matched.first;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => StudentMainScreen(
                studentName: matched.first.name,
                studentId: matched.first.studentId,
              ),
            ),
          );
        } else {
          _showNotice("학번 또는 비밀번호가 일치하지 않습니다.");
        }
      } else {
        final matched = Professor.list.where((p) => p.profCode == id).toList();
        if (matched.isNotEmpty) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ProfessorMainScreen(
                profName: matched.first.name,
                profCode: matched.first.profCode,
              ),
            ),
          );
        } else {
          _showNotice("교수코드가 일치하지 않습니다.");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8F1FF),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.school, size: 40, color: Color(0xFF1B64F2)),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    _isSignUpMode ? "회원가입" : "수강신청 시스템",
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  ),
                ),
                const SizedBox(height: 6),
                Center(
                  child: Text(
                    _isSignUpMode ? "필요한 정보를 입력해 계정을 만드세요" : "로그인 후 서비스를 이용하세요",
                    style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                  ),
                ),
                const SizedBox(height: 24),
                if (_isSignUpMode) ...[
                  const Text("이름", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF334155))),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    decoration: _inputDeco("이름을 입력하세요", Icons.person_outline),
                  ),
                  const SizedBox(height: 16),
                ],
                Text(
                  _userTypeIndex == 0 ? "학번 / 교수코드" : "교수코드",
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _idController,
                  decoration: _inputDeco(
                    _userTypeIndex == 0 ? "학번 또는 교수코드를 입력하세요" : "교수코드를 입력하세요",
                    Icons.person,
                  ),
                ),
                const SizedBox(height: 16),
                const Text("비밀번호", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF334155))),
                const SizedBox(height: 8),
                TextField(
                  controller: _pwController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF94A3B8), size: 20),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: const Color(0xFF94A3B8),
                        size: 20,
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    hintText: "비밀번호를 입력하세요",
                    hintStyle: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 14),
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B64F2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: Text(
                      _isSignUpMode ? "회원가입 완료" : "로그인",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: const [
                    Expanded(child: Divider(color: Color(0xFFE2E8F0))),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text("또는", style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                    ),
                    Expanded(child: Divider(color: Color(0xFFE2E8F0))),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: OutlinedButton(
                          onPressed: () => setState(() => _userTypeIndex = 0),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: _userTypeIndex == 0 ? const Color(0xFF1B64F2) : const Color(0xFFCBD5E1)),
                            backgroundColor: _userTypeIndex == 0 ? const Color(0xFFEFF6FF) : Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Text(
                            "학생 ${_isSignUpMode ? '가입' : '로그인'}",
                            style: TextStyle(color: _userTypeIndex == 0 ? const Color(0xFF1B64F2) : const Color(0xFF64748B), fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: OutlinedButton(
                          onPressed: () => setState(() => _userTypeIndex = 1),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: _userTypeIndex == 1 ? const Color(0xFF1B64F2) : const Color(0xFFCBD5E1)),
                            backgroundColor: _userTypeIndex == 1 ? const Color(0xFFEFF6FF) : Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Text(
                            "교수 ${_isSignUpMode ? '가입' : '로그인'}",
                            style: TextStyle(color: _userTypeIndex == 1 ? const Color(0xFF1B64F2) : const Color(0xFF64748B), fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _isSignUpMode = !_isSignUpMode;
                        _nameController.clear();
                        _pwController.clear();
                      });
                    },
                    child: Text(
                      _isSignUpMode ? "이미 계정이 있으신가요? 로그인" : "계정이 없으신가요? 회원가입",
                      style: const TextStyle(color: Color(0xFF64748B), fontSize: 13, decoration: TextDecoration.underline),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDeco(String hint, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: const Color(0xFF94A3B8), size: 20),
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
    );
  }
}