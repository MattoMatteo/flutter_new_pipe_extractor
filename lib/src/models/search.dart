part of 'models.dart';

enum SearchContentFilters {
  all("all"),
  videos("videos"),
  channels("channels"),
  playlists("playlists"),
  musicSongs("music_songs"),
  musicVideos("music_videos"),
  musicAlbums("music_albums"),
  musicPlaylists("music_playlists");

  final String label;
  const SearchContentFilters(this.label);
}

enum SearchResultType {
  @JsonValue('STREAM')
  video,
  @JsonValue('CHANNEL')
  channel,
  @JsonValue('PLAYLIST')
  playlist,
}

enum StreamInfoType {
  @JsonValue('NONE')
  none,
  @JsonValue('VIDEO_STREAM')
  videoStream,
  @JsonValue('AUDIO_STREAM')
  audioStream,
  @JsonValue('LIVE_STREAM')
  liveStream,
  @JsonValue('AUDIO_LIVE_STREAM')
  audioLiveStream,
  @JsonValue('POST_LIVE_STREAM')
  postLiveStream,
  @JsonValue('POST_LIVE_AUDIO_STREAM')
  postLiveAudioStream,
}

enum PlaylistInfoType {
  @JsonValue('NORMAL')
  normal,
  @JsonValue('MIX_STREAM')
  mixStream,
  @JsonValue('MIX_MUSIC')
  mixMusic,
  @JsonValue('MIX_CHANNEL')
  mixChannel,
  @JsonValue('MIX_GENRE')
  mixGenre,
}

abstract class SearchResultItem {
  final SearchResultType infoType;
  final String url;
  final String name;
  @JsonKey(defaultValue: [])
  final List<Thumbnail> thumbnails;

  SearchResultItem({
    required this.infoType,
    required this.url,
    required this.name,
    required this.thumbnails,
  });
}

@JsonSerializable()
class VideoSearchResultItem extends SearchResultItem {
  // YouTube Music song results by artists without a YouTube channel have no
  // uploaderUrl (e.g. 4 of 20 for "THE END OF US PAVÉ"): default the
  // descriptive fields so one such item doesn't fail the whole search.
  final StreamInfoType streamType;
  @JsonKey(defaultValue: '')
  final String uploaderName;
  final String? shortDescription;
  final String? textualUploadDate;
  final DateWrapper? uploadDate;
  @JsonKey(defaultValue: 0)
  final int viewCount;
  @JsonKey(defaultValue: 0)
  final int duration;
  @JsonKey(defaultValue: '')
  final String uploaderUrl;
  @JsonKey(defaultValue: [])
  final List<Thumbnail> uploaderAvatars;
  @JsonKey(defaultValue: false)
  final bool uploaderVerified;
  @JsonKey(defaultValue: false)
  final bool shortFormContent;

  VideoSearchResultItem({
    required this.streamType,
    required this.uploaderName,
    this.shortDescription,
    required this.uploadDate,
    required this.viewCount,
    required this.duration,
    required this.uploaderUrl,
    required this.uploaderAvatars,
    required this.uploaderVerified,
    required this.shortFormContent,
    required super.infoType,
    required super.url,
    required super.name,
    required super.thumbnails,
    this.textualUploadDate,
  });

  factory VideoSearchResultItem.fromJson(Map<String, dynamic> json) =>
      _$VideoSearchResultItemFromJson(json);
  Map<String, dynamic> toJson() => _$VideoSearchResultItemToJson(this);
}

@JsonSerializable()
class ChannelSearchResultItem extends SearchResultItem {
  final InfoDescription? description;
  final int subscriberCount;
  final int streamCount;
  final bool verified;

  ChannelSearchResultItem({
    required this.subscriberCount,
    required this.streamCount,
    required this.verified,
    required super.infoType,
    required super.url,
    required super.name,
    required super.thumbnails,
    this.description,
  });

  factory ChannelSearchResultItem.fromJson(Map<String, dynamic> json) =>
      _$ChannelSearchResultItemFromJson(json);
  Map<String, dynamic> toJson() => _$ChannelSearchResultItemToJson(this);
}

@JsonSerializable()
class PlaylistSearchResultItem extends SearchResultItem {
  final String uploaderName;
  final String? uploaderUrl;
  final bool uploaderVerified;
  final int? videoCount;
  final InfoDescription? description;
  final PlaylistInfoType playlistType;

  PlaylistSearchResultItem({
    required this.uploaderName,
    required this.uploaderVerified,
    required this.playlistType,
    required super.infoType,
    required super.url,
    required super.name,
    required super.thumbnails,
    this.description,
    this.videoCount,
    this.uploaderUrl,
  });

  factory PlaylistSearchResultItem.fromJson(Map<String, dynamic> json) =>
      _$PlaylistSearchResultItemFromJson(json);
  Map<String, dynamic> toJson() => _$PlaylistSearchResultItemToJson(this);
}
