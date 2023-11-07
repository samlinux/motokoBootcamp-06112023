
import Buffer "mo:base/Buffer";
import Result "mo:base/Result";
import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";
import Iter "mo:base/Iter";

actor {

  type Member = { name: Text;age : Nat; };
  type Result<Ok, Err> = {#ok : Ok; #err : Err};

  let name : Text = "SDG-DAO";
  let goals = Buffer.Buffer<Text>(10);
  var members = HashMap.HashMap<Principal, Member>(1, Principal.equal, Principal.hash);
  
  private var manifesto : Text = "DEMO for MotokoBootcamp";

  public shared query func getName() : async Text {
    return name;
  };

  public shared query func getManifesto() : async Text {
    return manifesto;
  };

  public shared func setManifesto(newManifesto : Text) : async () {
    manifesto := newManifesto;
  };

  public shared func addGoal(goal : Text) : async () {
    goals.add(goal);
  };

  public shared query func getGoals() : async [Text] {
    return Buffer.toArray(goals);
  };

  public shared ({ caller }) func addMember(member : Member) : async Result<(),Text> {
    members.put(caller, member);
    return #ok();
  };

  public shared query func getMember(principal : Principal) : async Result<Member,Text> {
    let member = members.get(principal);
    switch (member){
      case (null) { return #err("Member not found")};
      case (?member) { return #ok(member)};
    };
  };

  public shared query func getAllMembers () : async [Member] {      
    let iter : Iter.Iter<Member> = members.vals();
    Iter.toArray<Member>(iter);
  };

  public shared query func numberOfMembers () : async Nat {      
    members.size();
  };

  public shared ({ caller }) func updateMember(member : Member) : async Result<(),Text> {
    let member = members.get(caller);
    switch (member){
      case (null) { 
        return #err("Caller is not a member of the DAO")
      };
      case (?member) { 
        members.put(caller, member);
        return #ok();
        };
    };
  };

  public shared ({ caller }) func removeMember(p : Principal) : async Result<(),Text> {
    let member = members.get(caller);
    switch (member){
      case (null) { 
        return #err("Caller is not a member of the DAO")
      };
      case (?member) { 
         members.delete(p);
        return #ok();
        };
    };
  };

  public shared (message) func whoami() : async Principal {
    return message.caller;
  };
  
  // Implement a name  function: shared query () -> async Text;
  /*
  public shared query func name2 () : async Text {      
    return "SDG-DAO";
  };
  */
};
