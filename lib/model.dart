class AddressModel {
  final String fullAddress;
  final String street;
  final String city;
  final String region;
  final String country;
  final String postCode;

  AddressModel({this.fullAddress, this.street, this.city, this.region, this.country, this.postCode});

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      fullAddress: json["data1"] as String,
      street: json["data4"] as String,
      city: json["data7"] as String,
      region: json["data8"] as String,
      country: json["data10"] as String,
      postCode: json["data9"] as String,
    );
  }
}

class OrganizationModel {
  final String company;
  final String jobTitle;
  final String departement;
  final String officeLocation;

  OrganizationModel({this.company, this.jobTitle, this.departement, this.officeLocation});

  @override
  toString() {
    return "{company: ${this.company}, jobTitle: ${this.jobTitle}, departement: ${this.departement}, officeLocation: ${this.officeLocation}";
  }

  factory OrganizationModel.fromJson(Map<String, dynamic> json) {
    return OrganizationModel(
        company: json["data1"] as String,
        jobTitle: json["data4"] as String,
        departement: json["data5"] as String,
        officeLocation: json["data9"] as String);
  }
}

class RelationModel {
  final String relation;
  final String relationType;

  RelationModel({this.relation, this.relationType});

  @override
  toString() {
    return "{relation: ${this.relation}, relationType: ${this.relationType}}";
  }

  factory RelationModel.fromJson(Map<String, dynamic> json) {
    List<String> relationTypeList = [
      "TYPE_ASSISTANT",
      "TYPE_BROTHER",
      "TYPE_CHILD",
      "TYPE_DOMESTIC_PARTNER",
      "TYPE_FATHER",
      "TYPE_FRIEND",
      "TYPE_MANAGER",
      "TYPE_MOTHER",
      "TYPE_PARTNER",
      "TYPE_REFERRED_BY",
      "TYPE_RELATIVE",
      "TYPE_SISTER",
      "TYPE_SPOUSE"
    ];

    int index = (int.tryParse(json["data2"]) - 1);
    String relationType = index != -1 ? relationTypeList[index] : null;

    return RelationModel(relation: json["data1"] as String, relationType: relationType);
  }
}

class EventModel {
  final String dateString;
  final String eventType;

  EventModel({this.dateString, this.eventType});

  @override
  toString() {
    return "{dateString: ${this.dateString} , eventType: ${this.eventType}}";
  }

  factory EventModel.fromJson(Map<String, dynamic> json) {
    List<String> eventTypeList = ["TYPE_ANNIVERSARY", "TYPE_BIRTHDAY", "TYPE_OTHER"];

    int index = (int.tryParse(json["data2"]) - 1);
    String eventTypeString = index != -1 ? eventTypeList[index] : null;

    return EventModel(dateString: json["data1"] as String, eventType: eventTypeString);
  }
}

class WebsiteModel {
  final String websiteUrl;
  final String websiteType;

  WebsiteModel({this.websiteUrl, this.websiteType});

  @override
  toString() {
    return "{websiteUrl: ${this.websiteUrl} , websiteType: ${this.websiteType}}";
  }

  factory WebsiteModel.fromJson(Map<String, dynamic> json) {
    List<String> websiteTypeList = ["TYPE_HOMEPAGE", "TYPE_BLOG", "TYPE_PROFILE", "TYPE_HOME", "TYPE_WORK", "TYPE_FTP", "TYPE_OTHER"];

    int index = (int.tryParse(json["data2"]) - 1);
    String websiteTypeString = index != -1 ? websiteTypeList[index] : null;

    return WebsiteModel(websiteUrl: json["data1"] as String, websiteType: websiteTypeString);
  }
}

class NoteModel {
  final String note;

  NoteModel({this.note});

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(note: json["data1"] as String);
  }
}

class ContactModel {
  final String phoneNumber;
  final String displayName;
  final List<String> email;
  final List<AddressModel> address;
  final OrganizationModel organization;
  final List<RelationModel> relation;
  final NoteModel note;
  final List<EventModel> event;
  final List<WebsiteModel> website;

  ContactModel(
      {this.phoneNumber,
        this.displayName,
        this.email,
        this.address,
        this.organization,
        this.relation,
        this.note,
        this.event,
        this.website});

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    List<AddressModel> addresModelList = [];
    List<RelationModel> relationModelList = [];
    List<EventModel> eventModelList = [];
    List<WebsiteModel> websiteModelList = [];
    List<String> emailList = [];
    OrganizationModel organizationModelResult;
    NoteModel noteModelResult;

    if (json["email"] != null) {
      List<dynamic> result = json["email"];
      result.forEach((item) {
        emailList.add(item);
      });
    }

    if (json["address"] != null) {
      List<dynamic> result = json["address"];
      result.forEach((item) {
        AddressModel eachItem = AddressModel.fromJson(Map<String, dynamic>.from(item));
        addresModelList.add(eachItem);
      });
    }

    if (json["organization"] != null) {
      Map<String, dynamic> result = Map.from(json["organization"]);
      organizationModelResult = OrganizationModel.fromJson(result);
    }

    if (json["relation"] != null) {
      List<dynamic> result = json["relation"];
      result.forEach((item) {
        RelationModel eachItem = RelationModel.fromJson(Map<String, dynamic>.from(item));
        relationModelList.add(eachItem);
      });
    }

    if (json["event"] != null) {
      List<dynamic> result = json["event"];
      result.forEach((item) {
        EventModel eachItem = EventModel.fromJson(Map<String, dynamic>.from(item));
        eventModelList.add(eachItem);
      });
    }

    if (json["website"] != null) {
      List<dynamic> result = json["website"];
      result.forEach((item) {
        WebsiteModel eachItem = WebsiteModel.fromJson(Map<String, dynamic>.from(item));
        websiteModelList.add(eachItem);
      });
    }

    if (json["note"] != null) {
      Map<String, dynamic> result = Map.from(json["note"]);
      noteModelResult = NoteModel.fromJson(result);
    }

    return ContactModel(
        phoneNumber: json["data1"] as String,
        displayName: json["display_name"] as String,
        email: emailList,
        address: addresModelList,
        organization: organizationModelResult,
        relation: relationModelList,
        note: noteModelResult,
        event: eventModelList,
        website: websiteModelList);
  }
}
