import 'dart:convert';

class Project {
  final int id;
  final String? adminId;
  final String? adminEmail;
  final String? adminGenId;
  final String? userId;
  final String? userEmail;
  final String? orgRoleId;
  final String? slugId;
  final String? slugName;
  final String projectName;
  final String? url;
  final String status;
  final String? expiry;
  final String? projectManager;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // New fields
  final String? amitTest; // Added new field
  final String? projectId; // Added new field
  final String? typeOfTask; // Added new field
  final String? taskId; // Added new field
  final String? wizardProjectName; // Added new field
  final String? youtube; // Added new field
  final String? facebookUrl; // Added new field
  final String? tiktok; // Added new field
  final String? slideshare; // Added new field
  final String? devopsschool; // Added new field
  final String? dailymotion; // Added new field
  final String? twitter; // Added new field
  final String? linkedin; // Added new field
  final String? instagram; // Added new field
  final String? tumblr; // Added new field
  final String? wordpress; // Added new field
  final String? pinterest; // Added new field
  final String? reddit; // Added new field
  final String? plurk; // Added new field
  final String? debugschool; // Added new field
  final String? blogger; // Added new field
  final String? medium; // Added new field
  final String? quora; // Added new field
  final String? professnow; // Added new field
  final String? github; // Added new field
  final String? hubpages; // Added new field
  final String? gurukulgalaxy; // Added new field
  final String? mymedicplus; // Added new field
  final String? holidaylandmark; // Added new field
  final String? facebookPage; // Added new field
  final String? website; // Added new field
  final String? emailAddress; // Added new field
  final String? userName; // Added new field
  final String? allUrl; // Added new field
  final String? pubkey; // Added new field
  final String? tokenid; // Added new field
  final String? tokenEngineer; // Added new field
  final String? password; // Added new field
  final String? pageUrl; // Added new field
  final String? maintenanceEngineer; // Added new field

  Project({
    required this.id,
    this.adminId,
    this.adminEmail,
    this.adminGenId,
    this.userId,
    this.userEmail,
    this.orgRoleId,
    this.slugId,
    this.slugName,
    required this.projectName,
    this.url,
    required this.status,
    this.expiry,
    this.projectManager,
    this.createdAt,
    this.updatedAt,
    // Initialize new fields
    this.amitTest,
    this.projectId,
    this.typeOfTask,
    this.taskId,
    this.wizardProjectName,
    this.youtube,
    this.facebookUrl,
    this.tiktok,
    this.slideshare,
    this.devopsschool,
    this.dailymotion,
    this.twitter,
    this.linkedin,
    this.instagram,
    this.tumblr,
    this.wordpress,
    this.pinterest,
    this.reddit,
    this.plurk,
    this.debugschool,
    this.blogger,
    this.medium,
    this.quora,
    this.professnow,
    this.github,
    this.hubpages,
    this.gurukulgalaxy,
    this.mymedicplus,
    this.holidaylandmark,
    this.facebookPage,
    this.website,
    this.emailAddress,
    this.userName,
    this.allUrl,
    this.pubkey,
    this.tokenid,
    this.tokenEngineer,
    this.password,
    this.pageUrl,
    this.maintenanceEngineer,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      adminId: json['admin_id'],
      adminEmail: json['admin_email'],
      adminGenId: json['admin_gen_id'],
      userId: json['user_id'],
      userEmail: json['user_email'],
      orgRoleId: json['u_org_role_id'],
      slugId: json['slug_id'],
      slugName: json['slugname'],
      projectName: json['project_name'],
      url: json['url'],
      status: json['status'],
      expiry: json['expiry'],
      projectManager: json['project_manager'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      // Initialize new fields
      amitTest: json['amit_test'],
      projectId: json['project_id'],
      typeOfTask: json['type_of_task'],
      taskId: json['task_id'],
      wizardProjectName: json['wizard_project_name'],
      youtube: json['youtube'],
      facebookUrl: json['facebooks'],
      tiktok: json['tiktok'],
      slideshare: json['slideshare'],
      devopsschool: json['devopsschool'],
      dailymotion: json['dailymotion'],
      twitter: json['twitter'],
      linkedin: json['linkedin'],
      instagram: json['instagram'],
      tumblr: json['tumblr'],
      wordpress: json['wordpress'],
      pinterest: json['pinterest'],
      reddit: json['reddit'],
      plurk: json['plurk'],
      debugschool: json['debugschool'],
      blogger: json['blogger'],
      medium: json['medium'],
      quora: json['quora'],
      professnow: json['professnow'],
      github: json['github'],
      hubpages: json['hubpages'],
      gurukulgalaxy: json['gurukulgalaxy'],
      mymedicplus: json['mymedicplus'],
      holidaylandmark: json['holidaylandmark'],
      facebookPage: json['facebook_page'],
      website: json['website'],
      emailAddress: json['email_address'],
      userName: json['user_name'],
      allUrl: json['all_url'],
      pubkey: json['pubkey'],
      tokenid: json['tokenid'],
      tokenEngineer: json['token_engineer'],
      password: json['password'],
      pageUrl: json['page_url'],
      maintenanceEngineer: json['maintenance_engineer'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'admin_id': adminId,
      'admin_email': adminEmail,
      'admin_gen_id': adminGenId,
      'user_id': userId,
      'user_email': userEmail,
      'u_org_role_id': orgRoleId,
      'slug_id': slugId,
      'slugname': slugName,
      'project_name': projectName,
      'url': url,
      'status': status,
      'expiry': expiry,
      'project_manager': projectManager,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      // Add new fields
      'amit_test': amitTest,
      'project_id': projectId,
      'type_of_task': typeOfTask,
      'task_id': taskId,
      'wizard_project_name': wizardProjectName,
      'youtube': youtube,
      'facebooks': facebookUrl,
      'tiktok': tiktok,
      'slideshare': slideshare,
      'devopsschool': devopsschool,
      'dailymotion': dailymotion,
      'twitter': twitter,
      'linkedin': linkedin,
      'instagram': instagram,
      'tumblr': tumblr,
      'wordpress': wordpress,
      'pinterest': pinterest,
      'reddit': reddit,
      'plurk': plurk,
      'debugschool': debugschool,
      'blogger': blogger,
      'medium': medium,
      'quora': quora,
      'professnow': professnow,
      'github': github,
      'hubpages': hubpages,
      'gurukulgalaxy': gurukulgalaxy,
      'mymedicplus': mymedicplus,
      'holidaylandmark': holidaylandmark,
      'facebook_page': facebookPage,
      'website': website,
      'email_address': emailAddress,
      'user_name': userName,
      'all_url': allUrl,
      'pubkey': pubkey,
      'tokenid': tokenid,
      'token_engineer': tokenEngineer,
      'password': password,
      'page_url': pageUrl,
      'maintenance_engineer': maintenanceEngineer,
    };
  }

  @override
  String toString() {
    return 'Project{id: $id, adminId: $adminId, adminEmail: $adminEmail, adminGenId: $adminGenId, userId: $userId, userEmail: $userEmail, orgRoleId: $orgRoleId, slugId: $slugId, slugName: $slugName, projectName: $projectName, url: $url, status: $status, expiry: $expiry, projectManager: $projectManager, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}

List<Project> projectFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Project>.from(data.map((item) => Project.fromJson(item)));
}

String projectToJson(Project data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}