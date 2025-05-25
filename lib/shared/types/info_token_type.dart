class FsRoot {
  int id;
  String cuid;

  FsRoot({required this.id, required this.cuid});

  factory FsRoot.fromJson(Map<String, dynamic> json) {
    return FsRoot(id: json['ID'], cuid: json['Cuid']);
  }
}

class InfoToken {
  final int userId;
  final String userCuid;
  final int companyId;
  final String companyCuid;
  final int customerId;
  final String customerCuid;
  final int customerGroupId;
  final String customerGroupCuid;
  final String name;
  final String email;
  final bool admin;
  final String? profilePicture;
  final String type; // "SYS", "CPN", "CGR", "CTM"
  final FsRoot? fsRoot;
  final bool isCustomerDocCenter;
  final List<dynamic> departments;
  final List<String> permissions;

  InfoToken({
    required this.userId,
    required this.userCuid,
    required this.companyId,
    required this.companyCuid,
    required this.customerId,
    required this.customerCuid,
    required this.customerGroupId,
    required this.customerGroupCuid,
    required this.name,
    required this.email,
    required this.admin,
    required this.profilePicture,
    required this.type,
    required this.fsRoot,
    required this.isCustomerDocCenter,
    required this.departments,
    required this.permissions,
  });

  factory InfoToken.fromJson(Map<String, dynamic> a) {
    var json = a['info'];
    FsRoot? fsRoot;
    if (json['FSRoot'] != null) {
      fsRoot = FsRoot.fromJson(json['FSRoot']);
    }

    return InfoToken(
      userId: json['UserId'],
      userCuid: json['UserCuid'],
      companyId: json['CompanyId'],
      companyCuid: json['CompanyCuid'],
      customerId: json['CustomerId'],
      customerCuid: json['CustomerCuid'],
      customerGroupId: json['CustomerGroupId'],
      customerGroupCuid: json['CustomerGroupCuid'],
      name: json['Name'],
      email: json['Email'],
      admin: json['Admin'],
      profilePicture: json['ProfilePicture'],
      type: json['Type'],
      fsRoot: fsRoot,
      isCustomerDocCenter: json['IsCustomerDocCenter'],
      departments: json['Departments'],
      permissions: List<String>.from(json['Permissions']),
    );
  }
}
