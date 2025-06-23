import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'deteksi_result.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  bool _isFrontCamera = true;
  bool _isRecording = false;
  int _currentStep = 0;
  int _remainingSeconds = 30;
  Timer? _timer;
  Timer? _frameTimer;
  bool _isProcessing = false;
  List<String> _capturedFrames = [];

  static const String backendUrl = 'https://evidently-moved-marmoset.ngrok-free.app/api/detection';

  final List<String> instructions = [
    "Kedipkan mata dan gerakan alis anda",
    "Gerakan bibir anda dengan natural",
    "Berikan senyum lebar, tunjukkan gigi",
  ];

  final List<Color> stepColors = [
    const Color(0xFF6B7280),
    const Color(0xFF9CA3AF),
    const Color(0xFF4B5563),
  ];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      _cameras = await availableCameras();
      if (_cameras!.isNotEmpty) {
        _controller = CameraController(
          _cameras![_isFrontCamera ? 1 : 0],
          ResolutionPreset.high,
          enableAudio: false,
        );
        await _controller!.initialize();
        setState(() {
          _isCameraInitialized = true;
        });
      }
    }
  }

  void _toggleCamera() async {
    if (_cameras != null && _cameras!.length > 1) {
      setState(() {
        _isFrontCamera = !_isFrontCamera;
        _isCameraInitialized = false;
      });

      await _controller?.dispose();
      _controller = CameraController(
        _cameras![_isFrontCamera ? 1 : 0],
        ResolutionPreset.high,
        enableAudio: false,
      );
      await _controller!.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
    }
  }

  void _startRecording() {
    setState(() {
      _isRecording = true;
      _currentStep = 0;
      _remainingSeconds = 30;
      _capturedFrames.clear();
    });
    _startDetectionTimer();
    _startFrameCapture();
  }

  void _startDetectionTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _remainingSeconds--;
        if (_remainingSeconds == 20) {
          _currentStep = 1;
        } else if (_remainingSeconds == 10) {
          _currentStep = 2;
        }
      });

      if (_remainingSeconds <= 0) {
        timer.cancel();
        _stopRecording();
      }
    });
  }

  void _startFrameCapture() {
    _frameTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (!_isRecording) {
        timer.cancel();
        return;
      }
      _captureFrame();
    });
  }

  Future<void> _captureFrame() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    try {
      final XFile image = await _controller!.takePicture();
      final Uint8List imageBytes = await image.readAsBytes();
      final String base64Image = base64Encode(imageBytes);
      _capturedFrames.add(base64Image);
    } catch (e) {
      print('Error capturing frame: $e');
    }
  }

  void _stopRecording() {
    _timer?.cancel();
    _frameTimer?.cancel();
    setState(() {
      _isRecording = false;
      _isProcessing = true;
    });
    _processDetection();
  }

  Future<void> _processDetection() async {
    if (_capturedFrames.isEmpty) {
      _showError('No frames captured');
      setState(() => _isProcessing = false);
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('$backendUrl/predict_bellspalsy'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'frames': _capturedFrames}),
      ).timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['success']) {
          _showDetectionResult(result);
        } else {
          _showError(result['error'] ?? 'Unknown error');
        }
      } else {
        _showError('Server error: ${response.statusCode}');
      }
    } catch (e) {
      _showError('Network error: $e');
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 3),
    ));
  }

  void _showDetectionResult([Map<String, dynamic>? result]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DeteksiResult(
        isPositive: result?['is_positive'] ?? false,
        confidence: result?['confidence'] ?? 0.0,
        percentage: result?['percentage'] ?? 0.0,
        prediction: result?['prediction'] ?? 'Unknown',
        confidenceLevel: result?['confidence_level'] ?? 'Unknown',
        totalFrames: result?['total_frames'] ?? 0,
        bellsPalsyFrames: result?['bellspalsy_frames'] ?? 0,
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _frameTimer?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isCameraInitialized
          ? Stack(
              children: [
                Positioned.fill(child: CameraPreview(_controller!)),

                // Instruction and countdown
                if (_isRecording)
                  Positioned(
                    top: 90,
                    left: 30,
                    right: 30,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            '$_remainingSeconds detik',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: stepColors[_currentStep].withOpacity(0.85),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Text('Langkah ${_currentStep + 1}/3',
                                  style: const TextStyle(color: Colors.white, fontSize: 12)),
                              const SizedBox(height: 4),
                              Text(
                                instructions[_currentStep],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        LinearProgressIndicator(
                          value: (30 - _remainingSeconds) / 30,
                          backgroundColor: Colors.white30,
                          valueColor: AlwaysStoppedAnimation(stepColors[_currentStep]),
                          minHeight: 4,
                        ),
                      ],
                    ),
                  ),

                // Tombol rekam dan flip
                Positioned(
                  bottom: 50,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: _isRecording ? _stopRecording : _startRecording,
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _isRecording ? Colors.white : Colors.grey[700],
                                border: Border.all(color: Colors.white, width: 3),
                              ),
                              child: Center(
                                child: _isRecording
                                    ? Container(
                                        width: 26,
                                        height: 26,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[800],
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                      )
                                    : Icon(Icons.videocam, color: Colors.white70, size: 26),
                              ),
                            ),
                          ),
                          const SizedBox(width: 24),
                          GestureDetector(
                            onTap: _isRecording ? null : _toggleCamera,
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withOpacity(0.5),
                              ),
                              child: const Icon(Icons.flip_camera_ios,
                                  color: Colors.white, size: 22),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                if (_isProcessing)
                  Container(
                    color: Colors.black54,
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: Colors.white),
                          SizedBox(height: 16),
                          Text('Menganalisis...', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
              ],
            )
          : const Center(child: CircularProgressIndicator(color: Colors.white)),
    );
  }
}