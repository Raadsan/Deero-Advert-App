import 'dart:io';
import 'package:deero_advert_app/features/auth/controllers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:deero_advert_app/core/constant.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AdvertProfileDetailsPage extends StatefulWidget {
  const AdvertProfileDetailsPage({super.key});

  @override
  State<AdvertProfileDetailsPage> createState() =>
      _AdvertProfileDetailsPageState();
}

class _AdvertProfileDetailsPageState extends State<AdvertProfileDetailsPage> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _isUpdating = false;

  Future<void> _pickImage(
    ImageSource source, {
    StateSetter? setModalState,
  }) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      if (setModalState != null) {
        setModalState(() {
          _imageFile = File(image.path);
        });
      }
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  void _showImageSourceDialog({StateSetter? setModalState}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Select Profile Picture",
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(IconlyLight.camera, color: Color(0xFF6B7280)),
              ),
              title: Text(
                "Take a Photo",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera, setModalState: setModalState);
              },
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(IconlyLight.image, color: Color(0xFF6B7280)),
              ),
              title: Text(
                "Choose from Gallery",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery, setModalState: setModalState);
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(
    BuildContext context,
    String currentName,
    String currentEmail,
    String currentPhone,
    String? currentImage,
  ) {
    final nameController = TextEditingController(text: currentName);
    final emailController = TextEditingController(text: currentEmail);
    final phoneController = TextEditingController(text: currentPhone);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              top: 20,
              left: 24,
              right: 24,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Edit Profile",
                      style: GoogleFonts.outfit(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Image Selection inside Bottom Sheet
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _showImageSourceDialog(setModalState: setModalState);
                        },
                        child: Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFF3F4F6),
                            image: _imageFile != null
                                ? DecorationImage(
                                    image: FileImage(_imageFile!),
                                    fit: BoxFit.cover,
                                  )
                                : (currentImage != null &&
                                      currentImage.isNotEmpty)
                                ? DecorationImage(
                                    image: NetworkImage(
                                      currentImage.startsWith('http')
                                          ? currentImage
                                          : BaseUrl + currentImage,
                                    ),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child:
                              (_imageFile == null &&
                                  (currentImage == null ||
                                      currentImage.isEmpty))
                              ? Center(
                                  child: Text(
                                    currentName.isNotEmpty
                                        ? currentName
                                              .substring(0, 1)
                                              .toUpperCase()
                                        : "U",
                                    style: GoogleFonts.outfit(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF374151),
                                    ),
                                  ),
                                )
                              : null,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            _showImageSourceDialog(
                              setModalState: setModalState,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Color(0xff660E0D),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              IconlyBold.camera,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: _buildTextField(
                      "Full Name",
                      nameController,
                      IconlyLight.profile,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: _buildTextField(
                      "Email Address",
                      emailController,
                      IconlyLight.message,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: _buildTextField(
                      "Phone Number",
                      phoneController,
                      IconlyLight.call,
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () async {
                        final success =
                            await Provider.of<UserProvider>(
                              context,
                              listen: false,
                            ).updateProfile(
                              fullname: nameController.text,
                              email: emailController.text,
                              phone: phoneController.text,
                              imageFile: _imageFile,
                            );
                        if (success) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Profile updated successfully!"),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Failed to update profile."),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff660E0D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        "Save Changes",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey[400], size: 20),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(IconlyLight.arrow_left, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Profile Details",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final user = userProvider.userModel?.user;
          if (user == null) {
            return const Center(child: Text("User not found"));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar Section
                Center(
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: _showImageSourceDialog,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFF3F4F6),
                            image: _imageFile != null
                                ? DecorationImage(
                                    image: FileImage(_imageFile!),
                                    fit: BoxFit.cover,
                                  )
                                : (user.image != null && user.image!.isNotEmpty)
                                ? DecorationImage(
                                    image: NetworkImage(
                                      user.image!.startsWith('http')
                                          ? user.image!
                                          : BaseUrl + user.image!,
                                    ),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child:
                              (_imageFile == null &&
                                  (user.image == null || user.image!.isEmpty))
                              ? Center(
                                  child: Text(
                                    user.fullname != null &&
                                            user.fullname!.isNotEmpty
                                        ? user.fullname!
                                              .substring(0, 1)
                                              .toUpperCase()
                                        : "U",
                                    style: GoogleFonts.outfit(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF374151),
                                    ),
                                  ),
                                )
                              : null,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _showImageSourceDialog,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Color(0xff660E0D),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              IconlyBold.camera,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                if (_imageFile != null) ...[
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => setState(() => _imageFile = null),
                        icon: const Icon(IconlyLight.close_square, size: 18),
                        label: Text(
                          "Cancel",
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[100],
                          foregroundColor: Colors.black87,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: _isUpdating
                            ? null
                            : () async {
                                setState(() => _isUpdating = true);
                                final success = await Provider.of<UserProvider>(
                                  context,
                                  listen: false,
                                ).updateProfile(
                                  fullname: user.fullname ?? "",
                                  email: user.email ?? "",
                                  phone: user.phone ?? "",
                                  imageFile: _imageFile,
                                );
                                if (success) {
                                  setState(() {
                                    _imageFile = null;
                                    _isUpdating = false;
                                  });
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Profile image updated successfully!",
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }
                                } else {
                                  setState(() => _isUpdating = false);
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Failed to update profile image.",
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              },
                        icon: _isUpdating
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(IconlyLight.upload, size: 18),
                        label: Text(
                          "Save Image",
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff660E0D),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 32),

                // Info Rows
                _buildInfoSection("Personal Information"),
                const SizedBox(height: 16),
                _buildInfoTile(
                  IconlyLight.profile,
                  "Full Name",
                  user.fullname ?? "Not Set",
                ),
                _buildInfoTile(
                  IconlyLight.message,
                  "Email Address",
                  user.email ?? "Not Set",
                ),
                _buildInfoTile(
                  IconlyLight.call,
                  "Phone Number",
                  user.phone ?? "Not Set",
                ),

                const SizedBox(height: 70),

                // Edit Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      _showEditDialog(
                        context,
                        user.fullname ?? "",
                        user.email ?? "",
                        user.phone ?? "",
                        user.image,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff660E0D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      "Edit Profile",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoSection(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF9CA3AF),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF6B7280), size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF111827),
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
