class NanoGptAccount {
  const NanoGptAccount({
    this.usdBalance,
    this.nanoBalance,
    this.subscriptionActive = false,
    this.subscriptionState,
    this.dailyUsed,
    this.dailyRemaining,
    this.dailyLimit,
    this.dailyResetAt,
    this.weeklyUsed,
    this.weeklyRemaining,
    this.weeklyLimit,
    this.weeklyResetAt,
    this.monthlyUsed,
    this.monthlyRemaining,
    this.monthlyLimit,
    this.monthlyResetAt,
  });

  final String? usdBalance;
  final String? nanoBalance;
  final bool subscriptionActive;
  final String? subscriptionState;
  final int? dailyUsed;
  final int? dailyRemaining;
  final int? dailyLimit;
  final DateTime? dailyResetAt;
  final int? weeklyUsed;
  final int? weeklyRemaining;
  final int? weeklyLimit;
  final DateTime? weeklyResetAt;
  final int? monthlyUsed;
  final int? monthlyRemaining;
  final int? monthlyLimit;
  final DateTime? monthlyResetAt;

  bool get hasSubscriptionWindow =>
      dailyRemaining != null ||
      weeklyRemaining != null ||
      monthlyRemaining != null;
}
