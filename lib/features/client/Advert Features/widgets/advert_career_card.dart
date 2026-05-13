import 'dart:ui';
import 'package:deero_advert_app/features/client/Advert%20Features/controllers/careers_provider.dart';
import 'package:deero_advert_app/features/client/Advert%20Features/models/careers_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class CareerCard extends StatefulWidget {
  final Data careerItem;
  const CareerCard({super.key, required this.careerItem});

  @override
  State<CareerCard> createState() => _CareerCardState();
}

class _CareerCardState extends State<CareerCard> {
  bool _expanded = false;

  void _showApplyDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          ApplicationFormDialog(careerItem: widget.careerItem),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return "";
    try {
      final date = DateTime.parse(dateStr);
      const months = [
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sep",
        "Oct",
        "Nov",
        "Dec",
      ];
      return "${months[date.month - 1]} ${date.day}, ${date.year}";
    } catch (e) {
      return "";
    }
  }

  /// Returns countdown string: "3d 2h left", "5h 10m left", "Expired"
  String? _expiryCountdown(String? expireDateStr) {
    if (expireDateStr == null || expireDateStr.isEmpty) return null;
    try {
      final expire = DateTime.parse(expireDateStr);
      final diff = expire.difference(DateTime.now());
      if (diff.isNegative) return "Expired";
      if (diff.inDays >= 1) {
        final h = diff.inHours % 24;
        return "${diff.inDays}d ${h}h left";
      }
      if (diff.inHours >= 1) {
        final m = diff.inMinutes % 60;
        return "${diff.inHours}h ${m}m left";
      }
      return "${diff.inMinutes}m left";
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final countdown = _expiryCountdown(widget.careerItem.expireDate);
    final isExpired = countdown == "Expired";
    final hasDescription =
        widget.careerItem.description != null &&
        widget.careerItem.description!.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header: type badge + expiry timer ─────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Job type badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xff660E0D).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.careerItem.type?.toUpperCase() ?? "FULL TIME",
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff660E0D),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  // Expiry countdown badge
                  if (countdown != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isExpired
                            ? Colors.red.withOpacity(0.08)
                            : const Color(0xff660E0D).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isExpired
                                ? Icons.timer_off_rounded
                                : Icons.timer_rounded,
                            size: 11,
                            color: isExpired
                                ? Colors.red
                                : const Color(0xff660E0D),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            countdown,
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: isExpired
                                  ? Colors.red
                                  : const Color(0xff660E0D),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 14),

              // ── Title ─────────────────────────────────────────────
              Text(
                widget.careerItem.title ?? "No Title",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff1f2937),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 6),

              // ── Location ──────────────────────────────────────────
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 14,
                    color: Colors.grey[500],
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      widget.careerItem.location ?? "No Location",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),

              // ── Expandable Description ────────────────────────────
              if (hasDescription) ...[
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => setState(() => _expanded = !_expanded),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.careerItem.description!,
                        maxLines: _expanded ? null : 2,
                        overflow: _expanded
                            ? TextOverflow.visible
                            : TextOverflow.ellipsis,
                        textAlign: TextAlign.justify,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.grey[700],
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _expanded ? "Show less" : "Read more",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff660E0D),
                            ),
                          ),
                          const SizedBox(width: 3),
                          Icon(
                            _expanded
                                ? Icons.keyboard_arrow_up_rounded
                                : Icons.keyboard_arrow_down_rounded,
                            size: 16,
                            color: const Color(0xff660E0D),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 16),
              const Divider(
                height: 1,
                thickness: 0.5,
                color: Color(0xffE5E7EB),
              ),
              const SizedBox(height: 14),

              // ── Footer: posted date + Apply button ─────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 13,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "Posted ${_formatDate(widget.careerItem.postedDate)}",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => _showApplyDialog(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xff660E0D),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Apply Now",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            size: 14,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ApplicationFormDialog extends StatefulWidget {
  final Data careerItem;
  const ApplicationFormDialog({super.key, required this.careerItem});

  @override
  State<ApplicationFormDialog> createState() => _ApplicationFormDialogState();
}

class _ApplicationFormDialogState extends State<ApplicationFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _portfolioUrlController = TextEditingController();
  late TextEditingController _positionController;

  @override
  void initState() {
    super.initState();
    _positionController = TextEditingController(text: widget.careerItem.title);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _portfolioUrlController.dispose();
    _positionController.dispose();
    super.dispose();
  }

  File? _cvFile;
  File? _portfolioFile;
  File? _certificateFile;

  Future<void> _pickFile(String type) async {
    FilePickerResult? result = await FilePicker.pickFiles(
      type: type == 'cv' ? FileType.custom : FileType.any,
      allowedExtensions: type == 'cv' ? ['pdf', 'doc', 'docx'] : null,
    );

    if (result != null) {
      setState(() {
        if (type == 'cv') _cvFile = File(result.files.single.path!);
        if (type == 'portfolio')
          _portfolioFile = File(result.files.single.path!);
        if (type == 'certificate')
          _certificateFile = File(result.files.single.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Apply for Position",
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff660E0D),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              Text(
                widget.careerItem.title ?? "",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              _buildTextField("Full Name", _nameController),
              const SizedBox(height: 16),
              _buildTextField(
                "Phone Number",
                _phoneController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                "Email Address",
                _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              _buildTextField("Position", _positionController, readOnly: true),
              const SizedBox(height: 24),
              Text(
                "Documents",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              // Large CV Box
              _buildLargeUploadBox(
                "Upload CV / Resume *",
                _cvFile,
                () => _pickFile('cv'),
              ),

              const SizedBox(height: 16),
              _buildTextField(
                "Portfolio Link (Optional)",
                _portfolioUrlController,
                isRequired: false,
              ),
              const SizedBox(height: 16),

              // Portfolio Link + Small Cert Box
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildSmallUploadBox(
                      "Education Cert *",
                      _certificateFile,
                      () => _pickFile('certificate'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),
              Consumer<CareersProvider>(
                builder: (context, provider, child) {
                  return SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: provider.isSubmitting ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff660E0D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: provider.isSubmitting
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              "Submit Application",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
    bool readOnly = false,
    bool isRequired = true,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      style: GoogleFonts.poppins(
        fontSize: 15,
        color: readOnly ? Colors.grey[600] : Colors.black87,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: Colors.grey[500]),
        filled: readOnly,
        fillColor: readOnly ? Colors.grey[50] : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xff660E0D)),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
      ),
      validator: (value) {
        if (isRequired && (value == null || value.isEmpty))
          return "Please enter $label";
        return null;
      },
    );
  }

  Widget _buildLargeUploadBox(String label, File? file, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        painter: DashedBorderPainter(
          color: file != null
              ? Colors.green.withOpacity(0.5)
              : Colors.grey.shade300,
          gap: 6,
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: file != null
                ? Colors.green.withOpacity(0.05)
                : const Color(0xffF9FAFB),
          ),
          child: Row(
            children: [
              Icon(
                file != null
                    ? Icons.check_circle
                    : Icons.insert_drive_file_outlined,
                color: file != null ? Colors.green : Colors.grey[500],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  file != null ? file.path.split('/').last : label,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: file != null ? Colors.black87 : Colors.grey[500],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.file_upload_outlined,
                color: Colors.grey[300],
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSmallUploadBox(String label, File? file, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        painter: DashedBorderPainter(
          color: file != null
              ? Colors.green.withOpacity(0.5)
              : Colors.grey.shade300,
          gap: 4,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: file != null
                ? Colors.green.withOpacity(0.05)
                : const Color(0xffF9FAFB),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                file != null ? Icons.check_circle : Icons.school_outlined,
                color: file != null ? Colors.green : Colors.grey[500],
                size: 20,
              ),
              const SizedBox(height: 4),
              Text(
                file != null ? "Selected" : label,
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: file != null ? Colors.green[700] : Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_cvFile == null) {
      _showErrorSnackBar("Please upload your CV");
      return;
    }
    if (_certificateFile == null) {
      _showErrorSnackBar("Please upload your Education Certificate");
      return;
    }
    if (_portfolioFile == null && _portfolioUrlController.text.isEmpty) {
      _showErrorSnackBar("Please provide a Portfolio Link or File");
      return;
    }

    final provider = context.read<CareersProvider>();
    final success = await provider.submitApplication(
      fullName: _nameController.text,
      position: widget.careerItem.title ?? "",
      phone: _phoneController.text,
      email: _emailController.text,
      careerId: widget.careerItem.id?.toString(),
      portfolioUrl: _portfolioUrlController.text,
      cvFile: _cvFile!,
      portfolioFile: _portfolioFile,
      certificateFile: _certificateFile,
    );

    if (success && mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Application submitted successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.submitError ?? "Submission failed"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;

  DashedBorderPainter({
    this.color = Colors.grey,
    this.strokeWidth = 1.0,
    this.gap = 5.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final Path path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          const Radius.circular(16),
        ),
      );

    final Path dashPath = Path();
    double distance = 0.0;
    for (final PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + gap),
          Offset.zero,
        );
        distance += gap * 2;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
