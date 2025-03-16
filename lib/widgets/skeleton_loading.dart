import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonLoading extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const SkeletonLoading({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.borderRadius = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Shimmer.fromColors(
      baseColor: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
      highlightColor: isDarkMode ? Colors.grey[700]! : Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[800] : Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class NewsCardSkeleton extends StatelessWidget {
  const NewsCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 이미지 스켈레톤
          const SkeletonLoading(
            height: 180,
            borderRadius: 12,
          ),
          
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 카테고리와 날짜 스켈레톤
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SkeletonLoading(
                      width: 80,
                      height: 24,
                      borderRadius: 16,
                    ),
                    SkeletonLoading(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: 16,
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // 제목 스켈레톤
                const SkeletonLoading(
                  height: 24,
                ),
                
                const SizedBox(height: 8),
                
                // 요약 스켈레톤 (여러 줄)
                const Column(
                  children: [
                    SkeletonLoading(height: 16),
                    SizedBox(height: 4),
                    SkeletonLoading(height: 16),
                    SizedBox(height: 4),
                    SkeletonLoading(height: 16),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // 작성자 스켈레톤
                const Row(
                  children: [
                    SkeletonLoading(
                      width: 16,
                      height: 16,
                      borderRadius: 8,
                    ),
                    SizedBox(width: 8),
                    SkeletonLoading(
                      width: 100,
                      height: 16,
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

class WeatherCardSkeleton extends StatelessWidget {
  const WeatherCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SkeletonLoading(
                      width: 120,
                      height: 48,
                    ),
                    const SizedBox(height: 8),
                    SkeletonLoading(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: 24,
                    ),
                  ],
                ),
                const SkeletonLoading(
                  width: 80,
                  height: 80,
                  borderRadius: 40,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildWeatherDetailSkeleton(),
                _buildWeatherDetailSkeleton(),
                _buildWeatherDetailSkeleton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherDetailSkeleton() {
    return Column(
      children: [
        const SkeletonLoading(
          width: 24,
          height: 24,
          borderRadius: 12,
        ),
        const SizedBox(height: 8),
        const SkeletonLoading(
          width: 40,
          height: 12,
        ),
        const SizedBox(height: 4),
        const SkeletonLoading(
          width: 60,
          height: 16,
        ),
      ],
    );
  }
}

class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 프로필 이미지 스켈레톤
        const SkeletonLoading(
          width: 120,
          height: 120,
          borderRadius: 60,
        ),
        const SizedBox(height: 16),
        
        // 이름 스켈레톤
        SkeletonLoading(
          width: MediaQuery.of(context).size.width * 0.4,
          height: 24,
        ),
        const SizedBox(height: 8),
        
        // 이메일 스켈레톤
        SkeletonLoading(
          width: MediaQuery.of(context).size.width * 0.6,
          height: 16,
        ),
        const SizedBox(height: 32),
        
        // 카드 스켈레톤
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SkeletonLoading(
                  width: 120,
                  height: 24,
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: List.generate(
                    4,
                    (index) => const SkeletonLoading(
                      width: 80,
                      height: 32,
                      borderRadius: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
} 