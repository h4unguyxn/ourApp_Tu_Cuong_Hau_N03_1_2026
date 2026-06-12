import 'package:flutter/material.dart';
import '../services/location_service.dart';

class LocationAppBarTitle extends StatefulWidget {
  final Color textColor;
  final Color iconColor;

  const LocationAppBarTitle({
    super.key,
    this.textColor = Colors.black87,
    this.iconColor = Colors.black54,
  });

  @override
  State<LocationAppBarTitle> createState() =>
      _LocationAppBarTitleState();
}

class _LocationAppBarTitleState
    extends State<LocationAppBarTitle> {
  final LocationService locationService = LocationService();

  @override
  void initState() {
    super.initState();
    locationService.getCurrentLocation();
  }

  Future<void> _openLocationDialog() async {
    final controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Địa chỉ giao hàng"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: "Nhập địa chỉ thủ công",
              hintText: "Ví dụ: Yên Nghĩa, Hà Đông, Hà Nội",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final success =
                    await locationService.getCurrentLocation();

                if (!context.mounted) return;

                Navigator.pop(context);

                if (!success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Không lấy được vị trí hiện tại",
                      ),
                    ),
                  );
                }
              },
              child: const Text("Dùng vị trí hiện tại"),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  locationService.setManualAddress(
                    controller.text.trim(),
                  );
                }

                Navigator.pop(context);
              },
              child: const Text("Lưu"),
            ),
          ],
        );
      },
    );

    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: locationService,
      builder: (context, child) {
        return InkWell(
          onTap: _openLocationDialog,
          child: Row(
            children: [
              Icon(
                Icons.location_on,
                color: widget.iconColor,
                size: 27,
              ),

              const SizedBox(width: 4),

              Expanded(
                child: Text(
                  locationService.addressText,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 15,
                    color: widget.textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}