// ignore_for_file: must_be_immutable

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saged_online_platform/bloc/platform_cubit.dart';
import 'package:saged_online_platform/bloc/platform_states.dart';
import 'package:saged_online_platform/constants/components.dart';
import 'package:saged_online_platform/constants/styles.dart';
import 'package:saged_online_platform/constants/widgets.dart';

import '../../generated/l10n.dart';
import 'lecture_details_screen.dart';

class LecturesScreen extends StatefulWidget {
  const LecturesScreen({super.key});

  @override
  State<LecturesScreen> createState() => _LecturesScreenState();
}

class _LecturesScreenState extends State<LecturesScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlatformCubit, PlatformStates>(
      builder: (context, state) {
        var cubit = PlatformCubit.get(context);
        final mutedColor = cubit.isDarkMode
            ? Colors.white.withValues(alpha: 0.5)
            : Colors.black.withValues(alpha: 0.45);

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).chapters,
                  style: AppTextStyles.headStyle,
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => cubit.getVideos(),
                    color: Components.setBgColor(cubit.isDarkMode),
                    child: ConditionalBuilder(
                      condition: cubit.videoList.isEmpty,
                      builder: (context) => ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          Container(
                            height: 250,
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: cubit.isDarkMode
                                  ? Colors.black.withValues(alpha: 0.25)
                                  : Colors.white.withValues(alpha: 0.55),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Components.setBgColor(
                                              cubit.isDarkMode)
                                          .withValues(alpha: 0.12),
                                    ),
                                    child: Icon(
                                      Icons.menu_book_outlined,
                                      size: 36,
                                      color: Components.setBgColor(
                                          cubit.isDarkMode),
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  Text(
                                    S.of(context).no_chapters_yet,
                                    style: AppTextStyles.body2Style.copyWith(
                                      color: cubit.isDarkMode
                                          ? Colors.white.withValues(alpha: 0.7)
                                          : Colors.black.withValues(alpha: 0.6),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.refresh_rounded,
                                          size: 18, color: mutedColor),
                                      const SizedBox(width: 6.0),
                                      Text(
                                        S.of(context).pull_refresh,
                                        style:
                                            AppTextStyles.body2Style.copyWith(
                                          fontSize: 13.0,
                                          color: mutedColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      fallback: (context) {
                        return ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final video = cubit.videoList[index];
                            return TweenAnimationBuilder<double>(
                              key: ValueKey(video.chapId),
                              // Capped so long lists don't get sluggish entrances.
                              duration: Duration(
                                milliseconds: 400 + (index.clamp(0, 6) * 100),
                              ),
                              tween: Tween(begin: 0.0, end: 1.0),
                              curve: Curves.easeOut,
                              builder: (context, value, child) {
                                return Transform.translate(
                                  offset: Offset(0, 30 * (1 - value)),
                                  child: Opacity(
                                    opacity: value,
                                    child: child,
                                  ),
                                );
                              },
                              child: BuildLecturesWidget(
                                cubit: cubit,
                                imgUrl: video.thumbnail,
                                title: video.title,
                                subTitle: video.subTitle,
                                isDarkMode: cubit.isDarkMode,
                                chapId: video.chapId,
                              ),
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 8.0),
                          itemCount: cubit.videoList.length,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class BuildLecturesWidget extends StatelessWidget {
  BuildLecturesWidget({
    super.key,
    required this.imgUrl,
    required this.isDarkMode,
    required this.title,
    required this.chapId,
    required this.cubit,
    this.subTitle,
  });
  String imgUrl;
  String title;
  String? subTitle;
  bool isDarkMode;
  String chapId;
  PlatformCubit cubit;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Components.push(
          context: context,
          widget: VideoDetails(
            cubit: cubit,
            thumbnail: imgUrl,
            chapId: chapId,
            title: title,
            subTitle: subTitle,
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: DefaultImage(
                imgUrl: imgUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            title,
            textAlign: TextAlign.start,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body1Style.copyWith(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (subTitle != null && subTitle!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                subTitle!,
                textAlign: TextAlign.start,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body2Style,
              ),
            ),
        ],
      ),
    );
  }
}
