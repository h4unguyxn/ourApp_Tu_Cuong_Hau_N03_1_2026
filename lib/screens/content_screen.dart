import 'package:flutter/material.dart';

class ContentScreen extends StatelessWidget {
  const ContentScreen({super.key});

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

          SizedBox(height: heightAuto * 0.04),

          _buildImageDouble(widthAuto, heightAuto),

          SizedBox(height: heightAuto * 0.04),

          _buildHeading(
            title: "Món ăn nổi bật",
            subtitle: "Danh sách món ăn được nhiều sinh viên lựa chọn",
          ),

          const SizedBox(height: 14),

          _buildHorizontalCard(
            title: "Cơm tấm",
            description:
                "Cơm tấm sườn nướng, bì, chả, trứng. Phù hợp cho bữa trưa nhanh.",
            buttonText: "Đặt món",
            icon: Icons.rice_bowl,
          ),
          _buildHorizontalCard(
            title: "Phở bò",
            description:
                "Phở bò truyền thống, nước dùng đậm vị, phục vụ nóng mỗi ngày.",
            buttonText: "Đặt món",
            icon: Icons.ramen_dining,
          ),
          _buildHorizontalCard(
            title: "Bún chả",
            description:
                "Bún chả Hà Nội với thịt nướng, nước chấm và rau sống.",
            buttonText: "Đặt món",
            icon: Icons.lunch_dining,
          ),

          SizedBox(height: heightAuto * 0.04),

          _buildHeading(
            title: "Danh mục món ăn",
            subtitle: "Các nhóm sản phẩm chính trong ứng dụng",
          ),

          const SizedBox(height: 14),

          GridView.count(
            crossAxisCount: widthAuto > 700 ? 3 : 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: widthAuto > 700 ? 0.95 : 0.85,
            children: [
              _buildGridCard(
                title: "Cơm",
                description: "Các món cơm phổ biến, dễ ăn, phù hợp sinh viên.",
                icon: Icons.rice_bowl,
              ),
              _buildGridCard(
                title: "Phở",
                description: "Món nước truyền thống, nóng hổi mỗi ngày.",
                icon: Icons.ramen_dining,
              ),
              _buildGridCard(
                title: "Đồ uống",
                description: "Trà đào, cà phê, nước ép và đồ uống giải khát.",
                icon: Icons.local_cafe,
              ),
              _buildGridCard(
                title: "Ăn nhanh",
                description: "Các món tiện lợi, phù hợp khi cần đặt nhanh.",
                icon: Icons.fastfood,
              ),
              _buildGridCard(
                title: "Món mới",
                description: "Những món ăn mới được cập nhật trong tuần.",
                icon: Icons.new_releases_outlined,
              ),
              _buildGridCard(
                title: "Khuyến mãi",
                description: "Các món đang có ưu đãi trong ứng dụng.",
                icon: Icons.local_offer_outlined,
              ),
            ],
          ),

          SizedBox(height: heightAuto * 0.04),

          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHero(double widthAuto, double heightAuto) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: heightAuto * 0.18,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: widthAuto * 0.06,
        vertical: heightAuto * 0.05,
      ),
      decoration: BoxDecoration(
        color: const Color(0xffeeeeee),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Content",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: Color(0xff222222),
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Danh sách nội dung và món ăn trong ứng dụng",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageDouble(double widthAuto, double heightAuto) {
    return Row(
      children: [
        Expanded(
          child: _imagePlaceholder(
            height: heightAuto * 0.18,
            icon: Icons.image_outlined,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _imagePlaceholder(
            height: heightAuto * 0.18,
            icon: Icons.image_outlined,
          ),
        ),
      ],
    );
  }

  Widget _imagePlaceholder({
    required double height,
    required IconData icon,
  }) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xffe7e7e7),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Icon(
        icon,
        size: 58,
        color: const Color(0xffd8d8d8),
      ),
    );
  }

  Widget _buildHeading({
    required String title,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xff222222),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalCard({
    required String title,
    required String description,
    required String buttonText,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: const Color(0xffeeeeee),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              icon,
              size: 38,
              color: Colors.black26,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff222222),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 11,
                    height: 1.4,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xffeeeeee),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    buttonText,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xff222222),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridCard({
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 72,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xffeeeeee),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              icon,
              size: 36,
              color: Colors.black26,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xff222222),
            ),
          ),

          const SizedBox(height: 6),

          Expanded(
            child: Text(
              description,
              style: const TextStyle(
                fontSize: 10,
                height: 1.35,
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