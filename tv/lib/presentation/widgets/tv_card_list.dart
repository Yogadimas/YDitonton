import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/styles/colors.dart';
import 'package:core/styles/text_styles.dart';
import 'package:core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/presentation/pages/tv_detail_page.dart';

class TVCard extends StatelessWidget {
  final TV tv;

  const TVCard(this.tv, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            TVDetailPage.routeName,
            arguments: tv.id,
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              CachedNetworkImage(
                imageUrl: '$baseImageUrl${tv.posterPath}',
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
                placeholder: (context, _) => Container(
                  height: 180,
                  color: Colors.grey.shade900,
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 180,
                  color: Colors.grey.shade900,
                  child: const Icon(Icons.error),
                ),
              ),
              Container(
                height: 180,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.5),
                      Colors.black.withValues(alpha: 0.95),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tv.name ?? '-',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: kHeading6.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      tv.overview ?? '-',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade300,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              if (tv.voteAverage != null && tv.voteAverage! > 0)
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: kMikadoYellow.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.black87, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          tv.voteAverage!.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
