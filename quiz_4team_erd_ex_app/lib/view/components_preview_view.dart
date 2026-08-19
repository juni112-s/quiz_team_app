import 'package:flutter/material.dart';

class ComponentsPreviewView extends StatefulWidget {
  const ComponentsPreviewView({super.key});

  @override
  State<ComponentsPreviewView> createState() => _ComponentsPreviewViewState();
}

class _ComponentsPreviewViewState extends State<ComponentsPreviewView> {
  String? _dropdownValue;
  bool _isLiked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("컴포넌트 모음"),
        backgroundColor: const Color(0xFF1B64F2),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Tag / Badge", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _badge("전공필수", const Color(0xFFEFF6FF), const Color(0xFF1B64F2)),
                _badge("전공선택", const Color(0xFFF0FDF4), const Color(0xFF16A34A)),
                _badge("수강중", const Color(0xFFDCFCE7), const Color(0xFF16A34A)),
                _badge("수강완료", const Color(0xFFF1F5F9), const Color(0xFF64748B)),
                _badge("취소", const Color(0xFFFEE2E2), const Color(0xFFEF4444)),
              ],
            ),
            const SizedBox(height: 24),
            const Text("Buttons", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B64F2)),
              child: const Text("Primary Button", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFF1B64F2))),
              child: const Text("Secondary Button", style: TextStyle(color: Color(0xFF1B64F2))),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {},
              child: const Text("텍스트 버튼", style: TextStyle(color: Color(0xFF1B64F2))),
            ),
            IconButton(
              icon: Icon(_isLiked ? Icons.favorite : Icons.favorite_border, color: Colors.red),
              onPressed: () => setState(() => _isLiked = !_isLiked),
            ),
            const SizedBox(height: 24),
            const Text("Dropdown Input", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _dropdownValue,
                  hint: const Text("선택하세요"),
                  isExpanded: true,
                  items: ["선택 1", "선택 2", "선택 3"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (val) => setState(() => _dropdownValue = val),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _badge(String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(4)),
      child: Text(label, style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }
}