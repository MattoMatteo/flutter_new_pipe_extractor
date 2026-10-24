part of 'models.dart';

@JsonSerializable()
class Thumbnail {
  final String url;
  final int width;
  final int height;

  Thumbnail({required this.url, required this.width, required this.height});

  factory Thumbnail.fromJson(Map<String, dynamic> json) =>
      _$ThumbnailFromJson(json);

  Map<String, dynamic> toJson() => _$ThumbnailToJson(this);
}

@JsonSerializable()
class Engagement {
  final int likes;
  final int dislikes;
  final int viewCount;

  Engagement({
    required this.likes,
    required this.dislikes,
    required this.viewCount,
  });

  factory Engagement.fromJson(Map<String, dynamic> json) =>
      _$EngagementFromJson(json);

  Map<String, dynamic> toJson() => _$EngagementToJson(this);
}

@JsonSerializable()
class VideoInfo extends Info {
  // YouTube sometimes returns reduced responses (e.g. to non-official clients)
  // without some descriptive fields: keep them optional / defaulted so parsing
  // doesn't throw and the streams can still be played.
  final StreamInfoType streamType;
  @JsonKey(defaultValue: [])
  final List<Thumbnail> thumbnails;
  @JsonKey(defaultValue: '')
  final String textualUploadDate;
  final DateWrapper? uploadDate;
  @JsonKey(defaultValue: 0)
  final int duration;
  @JsonKey(defaultValue: 0)
  final int ageLimit;
  final InfoDescription? description;

  @JsonKey(defaultValue: 0)
  final int viewCount;
  @JsonKey(defaultValue: 0)
  final int likeCount;
  @JsonKey(defaultValue: 0)
  final int dislikeCount;

  @JsonKey(defaultValue: '')
  final String uploaderName;
  @JsonKey(defaultValue: '')
  final String uploaderUrl;
  @JsonKey(defaultValue: [])
  final List<Thumbnail> uploaderAvatars;
  @JsonKey(defaultValue: false)
  final bool uploaderVerified;
  @JsonKey(defaultValue: 0)
  final int uploaderSubscriberCount;

  @JsonKey(defaultValue: '')
  final String subChannelName;
  @JsonKey(defaultValue: '')
  final String subChannelUrl;
  @JsonKey(defaultValue: [])
  final List<Thumbnail> subChannelAvatars;

  @JsonKey(defaultValue: [])
  final List<VideoStream> videoStreams;
  @JsonKey(defaultValue: [])
  final List<AudioStream> audioStreams;
  @JsonKey(defaultValue: [])
  final List<VideoStream> videoOnlyStreams;

  @JsonKey(defaultValue: '')
  final String dashMpdUrl;
  @JsonKey(defaultValue: '')
  final String hlsUrl;

  // final List<InfoItem> relatedItems;

  @JsonKey(defaultValue: 0)
  final int startPosition;

  // final List<SubtitlesStream> subtitles = List.of();

  // final String host = "";
  // final StreamExtractor.Privacy privacy;
  @JsonKey(defaultValue: '')
  final String category;
  @JsonKey(defaultValue: '')
  final String licence;
  @JsonKey(defaultValue: '')
  final String supportInfo;

  // final Locale language = null;
  @JsonKey(defaultValue: [])
  final List<String> tags;

  // final List<StreamSegment> streamSegments = List.of();
  // final List<MetaInfo> metaInfo = List.of();
  @JsonKey(defaultValue: false)
  final bool shortFormContent;

  VideoInfo({
    required super.id,
    required super.url,
    required super.originalUrl,
    required super.name,
    required this.streamType,
    required this.thumbnails,
    required this.textualUploadDate,
    this.uploadDate,
    required this.duration,
    required this.ageLimit,
    this.description,
    required this.viewCount,
    required this.likeCount,
    required this.dislikeCount,
    required this.uploaderName,
    required this.uploaderUrl,
    required this.uploaderAvatars,
    required this.uploaderVerified,
    required this.uploaderSubscriberCount,
    required this.subChannelName,
    required this.subChannelUrl,
    required this.subChannelAvatars,
    required this.videoStreams,
    required this.audioStreams,
    required this.videoOnlyStreams,
    required this.dashMpdUrl,
    required this.hlsUrl,
    required this.startPosition,
    required this.category,
    required this.licence,
    required this.supportInfo,
    required this.tags,
    required this.shortFormContent,
  });

  factory VideoInfo.fromJson(Map<String, dynamic> json) =>
      _$VideoInfoFromJson(json);

  Map<String, dynamic> toJson() => _$VideoInfoToJson(this);
}
