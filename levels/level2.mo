/**
 * Level 2
 */
import Result "mo:base/Result";
import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";
import Iter "mo:base/Iter";

actor {
  type Member = {
    name: Text;
    age : Nat;
  };

  type Result<Ok, Err> = {#ok : Ok; #err : Err};

  let members = HashMap.HashMap<Principal, Member>(1, Principal.equal, Principal.hash);

  public shared ({ caller }) func addMember(name : Text, age : Nat) : async Result<(),Text> {
    if(Principal.isAnonymous(caller)){
        return #err("Anonymous identities cannot be registered");
    };
    let member : Member = { name; age; };
    members.put(caller, member);
    return #ok();
  };

  public shared query func getMember(p : Principal) : async ?Member {
    members.get(p);
  };

  public shared query func getAllMembers () : async [Member] {      
    let iter : Iter.Iter<Member> = members.vals();
    Iter.toArray<Member>(iter);
  };

  public shared query func numberOfMembers () : async Nat {      
    members.size();
  };

  public shared ({ caller }) func updateMember(name : Text, age : Nat) : async Result<(),Text> {
    if(Principal.isAnonymous(caller)){
      return #err("Anonymous identities cannot be updated");
    }
    else {
      let member = members.get(caller);
      if(member == null) {
        return #err("Caller is not a member of the DAO");
      }
      else {
       let member : Member = { name; age; };
        members.put(caller, member);
        return #ok();
      }
    }
  };

  public shared func removeMember(p : Principal) : async Result<(),Text> {
    if(Principal.isAnonymous(p)){
      return #err("Anonymous identities cannot be removed");
    }
    else {
      let member = members.get(p);
      if(member == null) {
        return #err("You are not a member of the DAO");
      }
      else {
        members.delete(p);
        return #ok();
      }
    }
  };
}