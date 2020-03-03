class Address {
  final String fullAddress;
  final String street;
  final String city;
  final String region;
  final String country;
  final String postCode;

  Address({this.fullAddress, this.street, this.city, this.region, this.country, this.postCode});


  @override
  String toString() {
    return 'Address{fullAddress: $fullAddress, street: $street, city: $city, region: $region, country: $country, postCode: $postCode}';
  }

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      fullAddress: json["data1"] as String,
      street: json["data4"] as String,
      city: json["data7"] as String,
      region: json["data8"] as String,
      country: json["data10"] as String,
      postCode: json["data9"] as String,
    );
  }
}

class Organization {
  final String company;
  final String jobTitle;
  final String departement;
  final String officeLocation;

  Organization({this.company, this.jobTitle, this.departement, this.officeLocation});

  @override
  toString() {
    return "{company: ${this.company}, jobTitle: ${this.jobTitle}, departement: ${this.departement}, officeLocation: ${this.officeLocation}";
  }

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
        company: json["data1"] as String,
        jobTitle: json["data4"] as String,
        departement: json["data5"] as String,
        officeLocation: json["data9"] as String);
  }
}

class Relation {
  final String relation;
  final RelationType relationType;

  Relation({this.relation, this.relationType});

  @override
  toString() {
    return "{relation: ${this.relation}, relationType: ${this.relationType}}";
  }

  factory Relation.fromJson(Map<String, dynamic> json) {
    RelationType result;
    int index = (int.tryParse(json["data2"]) - 1);

    switch (index) {
      case 0:
        result = RelationType.assistant;
        break;
      case 1:
        result = RelationType.brother;
        break;
      case 2:
        result = RelationType.child;
        break;
      case 3:
        result = RelationType.domesticPartner;
        break;
      case 4:
        result = RelationType.father;
        break;
      case 5:
        result = RelationType.friend;
        break;
      case 6:
        result = RelationType.manager;
        break;
      case 7:
        result = RelationType.mother;
        break;
      case 8:
        result = RelationType.partner;
        break;
      case 9:
        result = RelationType.referredBy;
        break;
      case 10:
        result = RelationType.relative;
        break;
      case 11:
        result = RelationType.sister;
        break;
      case 12:
        result = RelationType.spouse;
        break;
      default:
        break;
    }

    return Relation(relation: json["data1"] as String, relationType: result);
  }
}

class Event {
  final int timeStamp;
  final EventType eventType;

  Event({this.timeStamp, this.eventType});

  @override
  toString() {
    return "{timeStamp: ${this.timeStamp} , eventType: ${this.eventType}}";
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    EventType result;
    int index = (json["data2"] - 1);

    switch (index) {
      case 0:
        result = EventType.anniversary;
        break;
      case 1:
        result = EventType.birthday;
        break;
      case 2:
        result = EventType.other;
        break;
      default:
        break;
    }

    return Event(timeStamp: json["data1"] as int, eventType: result);
  }
}

class Website {
  final String websiteUrl;
  final WebsiteType websiteType;

  Website({this.websiteUrl, this.websiteType});

  @override
  toString() {
    return "{websiteUrl: ${this.websiteUrl} , websiteType: ${this.websiteType}}";
  }

  factory Website.fromJson(Map<String, dynamic> json) {
    WebsiteType result;
    int index =  (int.tryParse(json["data2"]) - 1);

    switch (index) {
      case 0:
        result = WebsiteType.homepage;
        break;
      case 1:
        result = WebsiteType.blog;
        break;
      case 2:
        result = WebsiteType.profile;
        break;
      case 3:
        result = WebsiteType.home;
        break;
      case 4:
        result = WebsiteType.work;
        break;
      case 5:
        result = WebsiteType.ftp;
        break;
      case 6:
        result = WebsiteType.other;
        break;
      default:
        break;
    }

    return Website(websiteUrl: json["data1"] as String, websiteType: result);
  }
}

class ContactModel {
  final String phoneNumber;
  final String displayName;
  final List<String> email;
  final List<Address> address;
  final Organization organization;
  final List<Relation> relation;
  final String note;
  final List<Event> event;
  final List<Website> website;

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


  @override
  String toString() {
    return 'Contact{phoneNumber: $phoneNumber, displayName: $displayName, email: ${email.toString()}, address: ${address.toString()}, organization: ${organization.toString()}, relation: ${relation.toString()}, note: $note, event: ${event.toString()}, website: ${website.toString()}';
  } //  @override
//  toString() => "result : ${phoneNumber} \n ${relation} \n ${event}";

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    List<Address> addresModelList = [];
    List<Relation> RelationList = [];
    List<Event> EventList = [];
    List<Website> WebsiteList = [];
    List<String> emailList = [];
    Organization OrganizationResult;

    if (json["email"] != null) {
      List<dynamic> result = json["email"];
      result.forEach((item) {
        emailList.add(item);
      });
    }

    if (json["address"] != null) {
      List<dynamic> result = json["address"];
      result.forEach((item) {
        Address eachItem = Address.fromJson(Map<String, dynamic>.from(item));
        addresModelList.add(eachItem);
      });
    }

    if (json["organization"] != null) {
      Map<String, dynamic> result = Map.from(json["organization"]);
      OrganizationResult = Organization.fromJson(result);
    }

    if (json["relation"] != null) {
      List<dynamic> result = json["relation"];
      result.forEach((item) {
        Relation eachItem = Relation.fromJson(Map<String, dynamic>.from(item));
        RelationList.add(eachItem);
      });
    }

    if (json["event"] != null) {
      List<dynamic> result = json["event"];
      result.forEach((item) {
        Event eachItem = Event.fromJson(Map<String, dynamic>.from(item));
        EventList.add(eachItem);
      });
    }

    if (json["website"] != null) {
      List<dynamic> result = json["website"];
      result.forEach((item) {
        Website eachItem = Website.fromJson(Map<String, dynamic>.from(item));
        WebsiteList.add(eachItem);
      });
    }

    return ContactModel(
        phoneNumber: json["data1"] as String,
        displayName: json["display_name"] as String,
        email: emailList,
        address: addresModelList,
        organization: OrganizationResult,
        relation: RelationList,
        note: json["note"] as String,
        event: EventList,
        website: WebsiteList);
  }
}

enum EventType { anniversary, birthday, other }

enum RelationType {
  assistant,
  brother,
  child,
  domesticPartner,
  father,
  friend,
  manager,
  mother,
  partner,
  referredBy,
  relative,
  sister,
  spouse
}

enum WebsiteType { homepage, blog, profile, home, work, ftp, other }
