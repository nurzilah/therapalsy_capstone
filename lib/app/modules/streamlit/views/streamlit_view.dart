import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../controllers/streamlit_controller.dart';

class StreamlitView extends StatefulWidget {
  const StreamlitView({super.key});

  @override
  State<StreamlitView> createState() => _StreamlitViewState();
}

class _StreamlitViewState extends State<StreamlitView> {
  WebViewController? _controller;
  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  void _initWebView() {
    try {
      final controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (url) {
              setState(() {
                isLoading = true;
                isError = false;
              });
            },
            onPageFinished: (url) {
              setState(() => isLoading = false);
            },
            onWebResourceError: (error) {
              setState(() {
                isLoading = false;
                isError = true;
              });
            },
          ),
        )
        ..loadRequest(Uri.parse('https://bells-pallsy.streamlit.app/'));

      setState(() {
        _controller = controller;
      });
    } catch (e, st) {
      print("WebView init error: $e");
      print(st);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ANALISIS STREAMLIT'),
        backgroundColor: const Color(0xFF316B5C),
        centerTitle: true,
        elevation: 2,
        titleTextStyle: const TextStyle(
          fontSize: 20,fontWeight: FontWeight.w700,
          letterSpacing: 2,
        ),
      ),
      body: Stack(
        children: [
          if (_controller != null && !isError)
            WebViewWidget(controller: _controller!),
          if (isLoading)
            const Center(child: CircularProgressIndicator()),
          if (isError)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Gagal memuat halaman Streamlit.\nPeriksa koneksi internet Anda.',
                  style: TextStyle(fontSize: 16, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
