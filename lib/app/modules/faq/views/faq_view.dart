import 'package:flutter/material.dart';

class FaqView extends StatefulWidget {
  const FaqView({super.key});

  @override
  State<FaqView> createState() => _FaqViewState();
}

class _FaqViewState extends State<FaqView> {
  final List<Map<String, String>> faqs = [
    {
      "question": "What is TheraPalsy?",
      "answer":
          "Therapalsy is an application designed to help users detect Bell's Palsy symptoms and provide appropriate therapy recommendations. The application uses intelligent algorithms to analyze symptoms and provide recovery guidance.",
    },
    {
      "question": "How does the Therapalsy app work?",
      "answer": "It uses intelligent algorithms to analyze symptoms and guide users.",
    },
    {
      "question": "What are the features of TheraPalsy?",
      "answer": "Detection, progress tracking, therapy recommendations, and more.",
    },
    {
      "question": "Is Therapalsy available for iOS and Android devices?",
      "answer": "Yes, it's available for both platforms.",
    },
    {
      "question": "Is there a cost to use the Therapalsy app?",
      "answer": "No, the app is free to use.",
    },
  ];

  int _expandedIndex = -1;

  @override
  Widget build(BuildContext context) {
    Color mainGreen = const Color(0xFF306A5A);
    Color lightRed = const Color(0xFFFF7D7D); // Warna merah muda sesuai desain

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: Colors.black87),
        centerTitle: true,
        title: const Text(
          'FAQ',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: faqs.length,
        separatorBuilder: (_, __) => Divider(color: Colors.grey.shade300),
        itemBuilder: (context, index) {
          final faq = faqs[index];
          final isExpanded = index == _expandedIndex;

          return Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  faq['question']!,
                  style: TextStyle(
                    color: mainGreen,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                trailing: Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: Colors.black54,
                  size: 26,
                ),
                onTap: () {
                  setState(() {
                    _expandedIndex = isExpanded ? -1 : index;
                  });
                },
              ),
              if (isExpanded)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 6, bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: lightRed,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    faq['answer']!,
                    style: const TextStyle(
                      color: Colors.white,
                      height: 1.4,
                      fontSize: 14.5,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
