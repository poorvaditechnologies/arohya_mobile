import 'package:flutter/material.dart';

class RelationshipManagerModel {
  final String id;
  final String name;
  final String title;
  final String initials;
  final bool available;
  final String availabilityLabel;
  final String? profileImageUrl;

  const RelationshipManagerModel({
    required this.id,
    required this.name,
    required this.title,
    required this.initials,
    required this.available,
    required this.availabilityLabel,
    this.profileImageUrl,
  });

  factory RelationshipManagerModel.fromJson(Map<String, dynamic> json) {
    return RelationshipManagerModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      title: json['title'] as String? ?? '',
      initials: json['initials'] as String? ?? '',
      available: json['available'] as bool? ?? false,
      availabilityLabel: json['availabilityLabel'] as String? ?? '',
      profileImageUrl: json['profileImageUrl'] as String?,
    );
  }
}

class SupportChannelModel {
  final String id;
  final String type;
  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionUrl;
  final String? iconUrl;
  final int sortOrder;

  const SupportChannelModel({
    required this.id,
    required this.type,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionUrl,
    this.iconUrl,
    this.sortOrder = 0,
  });

  factory SupportChannelModel.fromJson(Map<String, dynamic> json) {
    final fallbackIconKey = json['fallbackIconKey'] as String? ?? '';
    return SupportChannelModel(
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? '',
      icon: _fallbackIcon(fallbackIconKey),
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      actionUrl: json['actionUrl'] as String?,
      iconUrl: json['iconUrl'] as String?,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
    );
  }

  static IconData _fallbackIcon(String key) {
    switch (key.toLowerCase()) {
      case 'phone':
        return Icons.phone_in_talk;
      case 'whatsapp':
      case 'chat':
        return Icons.chat_bubble_outline;
      case 'email':
      case 'mail':
        return Icons.mail_outline;
      default:
        return Icons.support_agent;
    }
  }
}

class SupportConfigModel {
  final RelationshipManagerModel relationshipManager;
  final List<SupportChannelModel> channels;

  const SupportConfigModel({
    required this.relationshipManager,
    required this.channels,
  });

  factory SupportConfigModel.fromJson(Map<String, dynamic> json) {
    final manager =
        (json['relationshipManager'] as Map?)?.cast<String, dynamic>() ??
        const <String, dynamic>{};
    final rawChannels = json['channels'] as List? ?? const [];
    final channels =
        rawChannels
            .whereType<Map>()
            .map(
              (item) =>
                  SupportChannelModel.fromJson(item.cast<String, dynamic>()),
            )
            .toList()
          ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return SupportConfigModel(
      relationshipManager: RelationshipManagerModel.fromJson(manager),
      channels: channels,
    );
  }
}
