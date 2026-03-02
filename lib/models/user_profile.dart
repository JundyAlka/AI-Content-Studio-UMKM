class UserProfile {
  final String uid;
  final String email;
  final String businessName;
  final String businessType; // e.g., F&B, Fashion, Service
  final String brandTone; // e.g., Formal, Playful
  final String targetAudience;
  final String businessDescription;
  final bool isOnboardingComplete;

  UserProfile({
    required this.uid,
    required this.email,
    this.businessName = '',
    this.businessType = '',
    this.brandTone = '',
    this.targetAudience = '',
    this.businessDescription = '',
    this.isOnboardingComplete = false,
  });

  UserProfile copyWith({
    String? uid,
    String? email,
    String? businessName,
    String? businessType,
    String? brandTone,
    String? targetAudience,
    String? businessDescription,
    bool? isOnboardingComplete,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      businessName: businessName ?? this.businessName,
      businessType: businessType ?? this.businessType,
      brandTone: brandTone ?? this.brandTone,
      targetAudience: targetAudience ?? this.targetAudience,
      businessDescription: businessDescription ?? this.businessDescription,
      isOnboardingComplete: isOnboardingComplete ?? this.isOnboardingComplete,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'businessName': businessName,
      'businessType': businessType,
      'brandTone': brandTone,
      'targetAudience': targetAudience,
      'businessDescription': businessDescription,
      'isOnboardingComplete': isOnboardingComplete,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      businessName: map['businessName'] ?? '',
      businessType: map['businessType'] ?? '',
      brandTone: map['brandTone'] ?? '',
      targetAudience: map['targetAudience'] ?? '',
      businessDescription: map['businessDescription'] ?? '',
      isOnboardingComplete: map['isOnboardingComplete'] ?? false,
    );
  }
}
