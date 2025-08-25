import 'package:flutter/material.dart';
import 'package:booking_app/services/flight_service.dart';
import 'package:booking_app/models/discount_model.dart';
import 'package:booking_app/utils/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class DiscountBannerList extends StatefulWidget {
  final FlightService flightService;

  const DiscountBannerList({Key? key, required this.flightService})
    : super(key: key);

  @override
  _DiscountBannerListState createState() => _DiscountBannerListState();
}

class _DiscountBannerListState extends State<DiscountBannerList> {
  final _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;
  List<DiscountModel> _discounts = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadDiscounts();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadDiscounts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final discounts = await widget.flightService.getDiscounts();
      if (mounted) {
        setState(() {
          _discounts = discounts;
          _isLoading = false;
        });
      }
      print('Loaded ${_discounts.length} discounts');
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Lỗi khi tải mã giảm giá: $e';
          _isLoading = false;
        });
      }
      print('Error fetching discounts: $e');
    }
  }

  void _updateClaimStatus(String code, bool isClaimed) {
    setState(() {
      _discounts =
          _discounts.map((discount) {
            if (discount.code == code) {
              return DiscountModel(
                code: discount.code,
                discountPercentage: discount.discountPercentage,
                validUntil: discount.validUntil,
                isActive: discount.isActive,
                documentId: discount.documentId,
              );
            }
            return discount;
          }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid ?? '';

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!));
    } else if (_discounts.isEmpty) {
      print('No discounts found');
      return const Center(child: Text('Chưa có mã giảm giá nào.'));
    }

    return Column(
      children: [
        SizedBox(
          height: 100,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _discounts.length,
            padEnds: true,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              final discount = _discounts[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: DiscountBanner(
                  discount: discount,
                  flightService: widget.flightService,
                  userId: userId,
                  onClaimed: () => _updateClaimStatus(discount.code, true),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _discounts.length,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 10 : 6,
              height: _currentPage == index ? 10 : 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    _currentPage == index
                        ? AppColors.primaryColor
                        : Colors.grey.withOpacity(0.4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DiscountBanner extends StatefulWidget {
  final DiscountModel discount;
  final FlightService flightService;
  final String userId;
  final VoidCallback onClaimed;

  const DiscountBanner({
    Key? key,
    required this.discount,
    required this.flightService,
    required this.userId,
    required this.onClaimed,
  }) : super(key: key);

  @override
  _DiscountBannerState createState() => _DiscountBannerState();
}

class _DiscountBannerState extends State<DiscountBanner> {
  bool _isClaimed = false;

  @override
  void initState() {
    super.initState();
    _checkIfClaimed();
  }

  Future<void> _checkIfClaimed() async {
    final isClaimed = await widget.flightService.checkIfDiscountClaimed(
      widget.userId,
      widget.discount.code,
    );
    if (mounted) {
      setState(() {
        _isClaimed = isClaimed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Container(
      height: 155,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.local_offer_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Ưu đãi giảm giá',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Container(
                            constraints: const BoxConstraints(maxWidth: 90),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'MÃ: ${widget.discount.code}',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Giảm ${widget.discount.discountPercentage}%',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.discount.validUntil != null
                            ? 'Đến ${DateFormat('dd/MM/yyyy').format(widget.discount.validUntil!)}'
                            : 'Không thời hạn',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white70,
                          fontWeight: FontWeight.w400,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Align(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                onTap:
                    _isClaimed
                        ? null
                        : () async {
                          try {
                            await widget.flightService.saveUsedDiscount(
                              widget.userId,
                              widget.discount.code,
                              '',
                            );
                            setState(() {
                              _isClaimed = true;
                            });
                            widget.onClaimed();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Đã nhận mã ${widget.discount.code}',
                                ),
                                backgroundColor: AppColors.primaryColor,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Lỗi khi nhận mã: $e'),
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          }
                        },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: _isClaimed ? Colors.grey : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    _isClaimed ? 'Đã nhận' : 'Nhận mã',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _isClaimed ? Colors.white : AppColors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
