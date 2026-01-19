import 'package:deero_enterprise_app/core/constant.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/controllers/service_provider.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/models/service_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AdvertServicepage extends StatefulWidget {
  const AdvertServicepage({super.key});

  @override
  State<AdvertServicepage> createState() => _AdvertServicepageState();
}

class _AdvertServicepageState extends State<AdvertServicepage> {
  @override
  void initState() {
    super.initState();
    // Ensure services are fetched if not already
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ServiceProvider>();
      if (provider.serviceModel == null && !provider.isLoading) {
        provider.getAllServices();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ServiceProvider>(
      builder: (context, serviceProvider, child) {
        if (serviceProvider.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (serviceProvider.error != null) {
          return Scaffold(
            body: Center(child: Text("Error: ${serviceProvider.error}")),
          );
        }

        final services = serviceProvider.serviceModel?.data ?? [];

        if (services.isEmpty) {
          return const Scaffold(
            body: Center(child: Text("No services available")),
          );
        }

        return DefaultTabController(
          length: services.length,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              title: Text(
                "Services",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2,
                  color: const Color(0xff660E0D),
                ),
              ),
              bottom: TabBar(
                isScrollable: true,
                indicatorColor: const Color(0xff660E0D),
                labelColor: const Color(0xff660E0D),
                unselectedLabelColor: Colors.grey,
                labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                tabs: services
                    .map((service) => Tab(text: service.serviceTitle))
                    .toList(),
              ),
            ),
            body: TabBarView(
              children: services.map((service) {
                return _buildServiceDetail(service);
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildServiceDetail(Data service) {
    final imageUrl = service.serviceIcon != null
        ? BaseUrl + service.serviceIcon!
        : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Service Image
          Center(
            child: SizedBox(
              height: 150,
              width: 150,
              child: _buildImage(imageUrl),
            ),
          ),
          const SizedBox(height: 20),

          // Service Title
          Text(
            service.serviceTitle ?? "Untitled Service",
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          const Divider(),
          const SizedBox(height: 10),

          // Packages Header
          Text(
            "Packages",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xff660E0D),
            ),
          ),
          const SizedBox(height: 10),

          // Packages List
          if (service.packages != null && service.packages!.isNotEmpty)
            ...service.packages!.map((package) => _buildPackageCard(package))
          else
            Text(
              "No packages available for this service.",
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
        ],
      ),
    );
  }

  Widget _buildImage(String? url) {
    if (url == null || url.isEmpty) {
      return const Icon(
        Icons.image_not_supported,
        size: 80,
        color: Colors.grey,
      );
    }

    if (url.toLowerCase().endsWith('.svg')) {
      return SvgPicture.network(
        url,
        fit: BoxFit.contain,
        placeholderBuilder: (_) =>
            const Center(child: CircularProgressIndicator()),
      );
    } else {
      return Image.network(
        url,
        fit: BoxFit.contain,
        loadingBuilder: (_, child, progress) => progress == null
            ? child
            : const Center(child: CircularProgressIndicator()),
        errorBuilder: (_, __, ___) =>
            const Icon(Icons.broken_image, size: 80, color: Colors.grey),
      );
    }
  }

  Widget _buildPackageCard(Packages package) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.grey[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  package.packageTitle ?? "Unnamed Package",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "\$${package.price?.toStringAsFixed(2) ?? "0.00"}",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff660E0D),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Features
            if (package.features != null && package.features!.isNotEmpty)
              ...package.features!.map(
                (feature) => Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 16,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          feature,
                          style: GoogleFonts.poppins(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
