class WebassetsModel {
  final int id;
  final String? adminId;
  final String? amitTest;
  final String? adminEmail;
  final String? userId;
  final String? projectId; // Ensure projectId is always treated as a String
  final String? projectName;
  final String? userEmail;
  final String? typeOfTask;
  final String? taskId;
  final String? wizardProjectName;
  final String? slugName;
  final String? slugId;
  final String? website;
  final String? emailAddress;
  final String? userName;
  final String? allUrl;
  final String? pubkey;
  final String? tokenid;
  final String? tokenEngineer;
  final String? password;
  final String? pageUrl;
  final DateTime? createdAt;

  // New social media fields
  final String? facebooks;
  final String? youtube;
  final String? tiktok;
  final String? slideshare;
  final String? devopsschool;
  final String? dailymotion;
  final String? twitter;
  final String? linkedin;
  final String? instagram;
  final String? tumblr;
  final String? wordpress;
  final String? pinterest;
  final String? reddit;
  final String? plurk;
  final String? debugschool;
  final String? blogger;
  final String? medium;
  final String? quora;
  final String? professnow;
  final String? github;
  final String? hubpages;
  final String? gurukulgalaxy;
  final String? mymedicplus;
  final String? holidaylandmark;
  final String? facebookPage; // For facebook_page

  WebassetsModel({
    required this.id,
    this.adminId,
    this.amitTest,
    this.adminEmail,
    this.userId,
    this.projectId,
    this.projectName,
    this.userEmail,
    this.typeOfTask,
    this.taskId,
    this.wizardProjectName,
    this.slugName,
    this.slugId,
    this.website,
    this.emailAddress,
    this.userName,
    this.allUrl,
    this.pubkey,
    this.tokenid,
    this.tokenEngineer,
    this.password,
    this.pageUrl,
    this.createdAt,

    // Initialize new fields
    this.facebooks,
    this.youtube,
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
  });

  // Factory constructor to parse JSON data and handle projectId type inconsistency
  factory WebassetsModel.fromJson(Map<String, dynamic> json) {
    return WebassetsModel(
      id: json['id'] as int,
      adminId: json['admin_id']?.toString(),
      amitTest: json['amit_test']?.toString(),
      adminEmail: json['admin_email'],
      userId: json['user_id'],
      projectId: json['project_id']?.toString(), // Convert to String if it's an int
      projectName: json['project_name'],
      userEmail: json['user_email'],
      typeOfTask: json['type_of_task'],
      taskId: json['task_id'],
      wizardProjectName: json['wizard_project_name'],
      slugName: json['slugname'],
      slugId: json['slug_id']?.toString(),
      website: json['website'],
      emailAddress: json['email_address'],
      userName: json['user_name'],
      allUrl: json['all_url'],
      pubkey: json['pubkey'],
      tokenid: json['tokenid'],
      tokenEngineer: json['token_engineer'],
      password: json['password'],
      pageUrl: json['page_url'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,

      // Map new social media fields from JSON
      facebooks: json['facebooks'],
      youtube: json['youtube'],
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'admin_id': adminId,
      'amit_test': amitTest,
      'admin_email': adminEmail,
      'user_id': userId,
      'project_id': projectId,
      'project_name': projectName,
      'user_email': userEmail,
      'type_of_task': typeOfTask,
      'task_id': taskId,
      'wizard_project_name': wizardProjectName,
      'slugname': slugName,
      'slug_id': slugId,
      'website': website,
      'email_address': emailAddress,
      'user_name': userName,
      'all_url': allUrl,
      'pubkey': pubkey,
      'tokenid': tokenid,
      'token_engineer': tokenEngineer,
      'password': password,
      'page_url': pageUrl,
      'created_at': createdAt?.toIso8601String(),

      // Include new fields in the JSON output
      'facebooks': facebooks,
      'youtube': youtube,
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
    };
  }

  @override
  String toString() {
  return 'WebassetsModel{'
      'id: $id, '
      'adminId: $adminId, '
      'amitTest: $amitTest, '
      'adminEmail: $adminEmail, '
      'userId: $userId, '
      'projectId: $projectId, '
      'projectName: $projectName, '
      'userEmail: $userEmail, '
      'typeOfTask: $typeOfTask, '
      'taskId: $taskId, '
      'wizardProjectName: $wizardProjectName, '
      'slugName: $slugName, '
      'slugId: $slugId, '
      'website: $website, '
      'emailAddress: $emailAddress, '
      'userName: $userName, '
      'allUrl: $allUrl, '
      'pubkey: $pubkey, '
      'tokenid: $tokenid, '
      'tokenEngineer: $tokenEngineer, '
      'password: $password, '
      'pageUrl: $pageUrl, '
      'createdAt: $createdAt, '
      'facebooks: $facebooks, '
      'youtube: $youtube, '
      'tiktok: $tiktok, '
      'slideshare: $slideshare, '
      'devopsschool: $devopsschool, '
      'dailymotion: $dailymotion, '
      'twitter: $twitter, '
      'linkedin: $linkedin, '
      'instagram: $instagram, '
      'tumblr: $tumblr, '
      'wordpress: $wordpress, '
      'pinterest: $pinterest, '
      'reddit: $reddit, '
      'plurk: $plurk, '
      'debugschool: $debugschool, '
      'blogger: $blogger, '
      'medium: $medium, '
      'quora: $quora, '
      'professnow: $professnow, '
      'github: $github, '
      'hubpages: $hubpages, '
      'gurukulgalaxy: $gurukulgalaxy, '
      'mymedicplus: $mymedicplus, '
      'holidaylandmark: $holidaylandmark, '
      'facebookPage: $facebookPage}';
}
}
