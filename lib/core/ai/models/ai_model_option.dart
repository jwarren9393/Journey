class AiModelOption {
  const AiModelOption({
    required this.id,
    required this.displayName,
    required this.provider,
    this.description,
  });

  final String id;
  final String displayName;
  final String provider;
  final String? description;
}

class AiModelGroup {
  const AiModelGroup({
    required this.provider,
    required this.models,
  });

  final String provider;
  final List<AiModelOption> models;
}
