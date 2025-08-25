import 'package:flutter/material.dart';

class HomeFooter extends StatelessWidget {
  const HomeFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 24.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.lightBlueAccent.withOpacity(0.18),
              Colors.white.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.10),
              blurRadius: 18,
              offset: Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Số liệu nổi bật: 2 dòng, mỗi dòng 3 mục
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: _buildStat(
                    icon: Icons.location_on,
                    number: '200+',
                    label: 'Địa điểm du lịch hấp dẫn',
                    color: Colors.blue[700],
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _buildStat(
                    icon: Icons.people,
                    number: '5000+',
                    label: 'Khách hàng hài lòng',
                    color: Colors.orange[800],
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _buildStat(
                    icon: Icons.handshake,
                    number: '120+',
                    label: 'Đối tác toàn cầu',
                    color: Colors.green[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: _buildStat(
                    icon: Icons.flag,
                    number: '50+',
                    label: 'Hướng dẫn viên chuyên nghiệp',
                    color: Colors.purple[700],
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _buildStat(
                    icon: Icons.emoji_events,
                    number: '10+',
                    label: 'Giải thưởng uy tín',
                    color: Colors.amber[800],
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _buildStat(
                    icon: Icons.star,
                    number: '4.9★',
                    label: 'Đánh giá trung bình',
                    color: Colors.red[400],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            // Giải thưởng (2 mục mỗi dòng)
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 32,
              runSpacing: 12,
              children: [
                _buildAward(
                  Icons.emoji_events,
                  'Top 10 Dịch vụ du lịch chất lượng cao',
                ),
                _buildAward(
                  Icons.workspace_premium,
                  'Giải thưởng Chất lượng vàng 2023',
                ),
              ],
            ),
            const SizedBox(height: 18),
            // Slogan
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: [
                  Text(
                    'Khám phá thế giới – Gắn kết yêu thương',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[800],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Trải nghiệm mới, cảm xúc mới',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.teal[600],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Địa chỉ, hotline
            Column(
              children: [
                Text(
                  'Công ty Du lịch Media YangNee\n123 Đường Mới, Quận 1, TP. HCM',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.phone, color: Colors.red, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'Hotline: 1800 1234',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat({
    required IconData icon,
    required String number,
    required String label,
    Color? color,
    bool small = false,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (color ?? Colors.blue).withOpacity(0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color ?? Colors.blue, size: small ? 22 : 28),
        ),
        const SizedBox(height: 6),
        Text(
          number,
          style: TextStyle(
            fontSize: small ? 15 : 20,
            fontWeight: FontWeight.bold,
            color: color ?? Colors.blue,
          ),
        ),
        const SizedBox(height: 2),
        SizedBox(
          width: 110,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildAward(IconData icon, String label) {
    return SizedBox(
      width: 150,
      child: Column(
        children: [
          Icon(icon, size: 40, color: Colors.amber[800]),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
