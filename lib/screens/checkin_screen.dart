import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../providers/event_provider.dart';
import '../widgets/glass_card.dart';
import '../utils/constants.dart';

class CheckinScreen extends StatefulWidget {
  const CheckinScreen({super.key});

  @override
  State<CheckinScreen> createState() => _CheckinScreenState();
}

class _CheckinScreenState extends State<CheckinScreen> with SingleTickerProviderStateMixin {
  final _manualIdController = TextEditingController();
  MobileScannerController cameraController = MobileScannerController();
  bool _isProcessing = false;
  
  late AnimationController _successController;
  late Animation<double> _successAnimation;

  @override
  void initState() {
    super.initState();
    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _successAnimation = CurvedAnimation(
      parent: _successController,
      curve: Curves.elasticOut,
    );
  }

  Future<void> _processCheckin(String id) async {
    if (id.isEmpty || _isProcessing) return;

    setState(() => _isProcessing = true);

    final error = await context.read<EventProvider>().checkInParticipant(id, "Participant ${id.substring(0, math.min(5, id.length))}");
    
    setState(() => _isProcessing = false);

    if (!mounted) return;

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error), 
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      _showSuccess();
      _manualIdController.clear();
    }
  }

  void _showSuccess() {
    _successController.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) _successController.reverse();
      });
    });
  }

  @override
  void dispose() {
    _manualIdController.dispose();
    cameraController.dispose();
    _successController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check-In'),
        actions: [
          ValueListenableBuilder<MobileScannerState>(
            valueListenable: cameraController,
            builder: (context, state, child) {
              return IconButton(
                icon: Icon(
                  state.torchState == TorchState.on ? Icons.flash_on : Icons.flash_off,
                  color: state.torchState == TorchState.on ? Colors.yellow : null,
                ),
                onPressed: () => cameraController.toggleTorch(),
              );
            },
          ),
          ValueListenableBuilder<MobileScannerState>(
            valueListenable: cameraController,
            builder: (context, state, child) {
              return IconButton(
                icon: Icon(
                  state.cameraDirection == CameraFacing.front ? Icons.camera_front : Icons.camera_rear,
                ),
                onPressed: () => cameraController.switchCamera(),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Stack(
                      children: [
                        MobileScanner(
                          controller: cameraController,
                          onDetect: (capture) {
                            final List<Barcode> barcodes = capture.barcodes;
                            for (final barcode in barcodes) {
                              if (barcode.rawValue != null) {
                                _processCheckin(barcode.rawValue!);
                                break;
                              }
                            }
                          },
                        ),
                        // Scanner Overlay
                        CustomPaint(
                          painter: ScannerOverlayPainter(),
                          child: Container(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text('OR ENTER MANUALLY', style: TextStyle(color: AppColors.textSecondary, letterSpacing: 1.2, fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: GlassCard(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          controller: _manualIdController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: 'Participant ID',
                            hintStyle: TextStyle(color: AppColors.textSecondary),
                            border: InputBorder.none,
                          ),
                          onSubmitted: (value) => _processCheckin(value),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton.filled(
                      onPressed: () => _processCheckin(_manualIdController.text),
                      icon: const Icon(Icons.arrow_forward),
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          // Success Overlay
          Center(
            child: ScaleTransition(
              scale: _successAnimation,
              child: Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: AppColors.accent.withOpacity(0.5), blurRadius: 30, spreadRadius: 10),
                  ],
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 80),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final width = size.width;
    final height = size.height;
    final scanSize = math.min(width, height) * 0.7;
    final left = (width - scanSize) / 2;
    final top = (height - scanSize) / 2;

    final rect = Rect.fromLTWH(left, top, scanSize, scanSize);
    
    // Draw corners
    final path = Path()
      ..moveTo(left, top + 40)
      ..lineTo(left, top)
      ..lineTo(left + 40, top)
      
      ..moveTo(left + scanSize - 40, top)
      ..lineTo(left + scanSize, top)
      ..lineTo(left + scanSize, top + 40)
      
      ..moveTo(left + scanSize, top + scanSize - 40)
      ..lineTo(left + scanSize, top + scanSize)
      ..lineTo(left + scanSize - 40, top + scanSize)
      
      ..moveTo(left + 40, top + scanSize)
      ..lineTo(left, top + scanSize)
      ..lineTo(left, top + scanSize - 40);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
