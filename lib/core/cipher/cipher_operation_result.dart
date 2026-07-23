class CipherOperationResult {
  const CipherOperationResult({required this.output, this.warnings = const []});

  final String output;
  final List<String> warnings;
}
