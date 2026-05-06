import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double widthAuto = MediaQuery.of(context).size.width; // Gives the width
    double heightAuto = MediaQuery.of(context).size.height; // Gives the height

    return Container(
      color: const Color(0xfff4f4f4),
      child: ListView(
        padding: EdgeInsets.all(widthAuto * 0.05),
        children: [
          _buildHero(widthAuto, heightAuto),

          SizedBox(height: heightAuto * 0.025),

          _buildInfoBox(),

          SizedBox(height: heightAuto * 0.03),

          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHero(double widthAuto, double heightAuto) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: heightAuto * 0.16,
      ),
      padding: EdgeInsets.all(widthAuto * 0.06),
      decoration: BoxDecoration(
        color: const Color(0xff222222),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "About Us",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          SizedBox(height: 8),

          Text(
            "Thông tin giới thiệu nhóm sinh viên và bài kiểm tra giữa kỳ.",
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),

          SizedBox(height: 18),

          Row(
            children: [
              Icon(
                Icons.school,
                color: Colors.white,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Phenikaa University",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Thông tin bài làm",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          _infoItem("Trường", "Phenikaa University"),
          _infoItem("Môn học", "Lập trình ứng dụng di động"),
          _infoItem("Framework", "Flutter"),
          _infoItem(
            "Nội dung",
            "Xây dựng các trang Home, Content và About dựa trên mẫu Figma.",
          ),

          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff222222),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {},
              child: const Text(
                "Submit",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 6),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final bool isSmall = constraints.maxWidth < 500;
              final double itemWidth = isSmall
                  ? (constraints.maxWidth - 12) / 2
                  : (constraints.maxWidth - 36) / 4;

              return Wrap(
                spacing: 12,
                runSpacing: 20,
                children: [
                  SizedBox(
                    width: itemWidth,
                    child: _brandColumn(),
                  ),
                  SizedBox(
                    width: itemWidth,
                    child: _footerColumn(
                      title: "Liên hệ",
                      normalItems: [
                        "Hotline (8–22h)",
                        "1900 xxxx",
                        "Địa điểm",
                        "Phenikaa University – Hà Nội",
                      ],
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    child: _footerColumn(
                      title: "Giao hàng",
                      normalItems: [
                        "30–45 phút khu nội thành",
                      ],
                      highlightItems: [
                        "Chính sách giao hàng",
                        "Phí vận chuyển",
                        "Đối tác giao hàng",
                      ],
                    ),
                  ),
                  SizedBox(
                    width: itemWidth,
                    child: _footerColumn(
                      title: "Hợp pháp & hỗ trợ",
                      highlightItems: [
                        "FAQ",
                        "Điều khoản sử dụng",
                        "Quyền riêng tư",
                      ],
                    ),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 20),

          Container(
            height: 1,
            color: Colors.black12,
          ),

          const SizedBox(height: 14),

          const Text(
            "© 2026 HCT Food. Bản demo ứng dụng.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _brandColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Thương hiệu",
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color(0xff222222),
          ),
        ),

        const SizedBox(height: 10),

        Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: const Color(0xff222222),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.restaurant_menu,
                size: 17,
                color: Colors.white,
              ),
            ),

            const SizedBox(width: 8),

            const Expanded(
              child: Text(
                "HCT Food",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff222222),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        const Text(
          "Đặt món nhanh — giao tận nơi",
          style: TextStyle(
            fontSize: 11,
            color: Colors.black54,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _footerColumn({
    required String title,
    List<String> normalItems = const [],
    List<String> highlightItems = const [],
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color(0xff222222),
          ),
        ),

        const SizedBox(height: 10),

        ...normalItems.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 7),
            child: Text(
              item,
              style: TextStyle(
                fontSize: 11,
                height: 1.35,
                color: item.contains("1900")
                    ? const Color(0xff222222)
                    : Colors.black54,
                fontWeight: item.contains("1900")
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ),
        ),

        ...highlightItems.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 7),
            child: Text(
              item,
              style: const TextStyle(
                fontSize: 11,
                height: 1.35,
                color: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}