import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _initialized = false;
  bool _recording = false;
  bool _uploading = false;
  int _questionIndex = 0;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        setState(() => _error = 'No camera found');
        return;
      }
      _controller = CameraController(
        _cameras!.first,
        ResolutionPreset.medium,
        imageFormatGroup: ImageFormatGroup.jpeg,
        enableAudio: true,
      );
      await _controller!.initialize();
      setState(() => _initialized = true);
    } catch (e) {
      setState(() => _error = 'Camera error: $e');
    }
  }

  Future<void> _startRecording() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    try {
      await _controller!.startVideoRecording();
      setState(() => _recording = true);
    } catch (e) {
      setState(() => _error = 'Start recording failed: $e');
    }
  }

  Future<void> _stopAndUpload() async {
    if (_controller == null || !_recording) return;
    try {
      final file = await _controller!.stopVideoRecording();
      setState(() {
        _recording = false;
        _uploading = true;
      });

      final domain = Uri.base.queryParameters['domain'] ?? '1_Python';
      final duration = int.tryParse(Uri.base.queryParameters['duration'] ?? '10') ?? 10;
      final auth = context.read<AuthProvider>();
      final username = auth.username ?? 'anonymous';
      final sessionId = 'Interview1_${DateTime.now().millisecondsSinceEpoch}';
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('currentSessionId', sessionId);

      await ApiService().uploadAnswer(
        videoPath: file.path,
        question: _questionIndex + 1,
        domain: domain,
        sessionId: sessionId,
        username: username,
      );

      if (mounted) {
        setState(() => _uploading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Answer uploaded successfully!')),
        );
        setState(() => _questionIndex++);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _uploading = false;
          _error = 'Upload failed: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final domain = Uri.base.queryParameters['domain'] ?? '1_Python';
    final duration = Uri.base.queryParameters['duration'] ?? '10';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Interview'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.go('/skills'),
          ),
        ],
      ),
      body: _error != null
          ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
          : !_initialized
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: _controller!.value.aspectRatio,
                          child: CameraPreview(_controller!),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(24),
                      color: Colors.black87,
                      child: Column(
                        children: [
                          Text(
                            'Domain: $domain | Duration: ${duration}min | Q${_questionIndex + 1}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 16),
                          if (_uploading)
                            const CircularProgressIndicator(color: Colors.white)
                          else
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (!_recording)
                                  FilledButton.icon(
                                    onPressed: _startRecording,
                                    icon: const Icon(Icons.fiber_manual_record),
                                    label: const Text('Start Recording'),
                                    style: FilledButton.styleFrom(backgroundColor: Colors.red),
                                  )
                                else
                                  FilledButton.icon(
                                    onPressed: _stopAndUpload,
                                    icon: const Icon(Icons.stop),
                                    label: const Text('Stop & Upload'),
                                  ),
                                const SizedBox(width: 16),
                                TextButton(
                                  onPressed: () => context.go('/final-report'),
                                  child: const Text('View Report'),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
