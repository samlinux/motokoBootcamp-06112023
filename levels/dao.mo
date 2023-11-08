
import Buffer "mo:base/Buffer";
import Result "mo:base/Result";
import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";
import Iter "mo:base/Iter";

import TrieMap "mo:base/TrieMap";
import Nat "mo:base/Nat";
import Hash "mo:base/Hash";

import Account "account";

actor {

  type Member = { name: Text;age : Nat; };
  type Result<Ok, Err> = {#ok : Ok; #err : Err};

  let name : Text = "SDG-DAO";

  let goals = Buffer.Buffer<Text>(10);
  var members = HashMap.HashMap<Principal, Member>(1, Principal.equal, Principal.hash);
  
  private var manifesto : Text = "DEMO for MotokoBootcamp";

  // level 1 - DAO definition
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

  // level 2 - members
  public shared ({ caller }) func addMember(member : Member) : async Result<(),Text> {
    switch (members.get(caller)){
      case (null) { 
        members.put(caller, member);
        return #ok();
      };
      case (?member) { 
        return #err("Sorry, you are already a member of the DAO");
      };
    };
  };

  public shared query func getMember(principal : Principal) : async Result<Member,Text> {
    let member = members.get(principal);
    switch (member){
      case (null) { 
        return #err("Member not found")
      };
      case (?member) { 
        return #ok(member)
      };
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
    switch (members.get(caller)){
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
    switch (members.get(caller)){
      case (null) { 
        return #err("Caller is not a member of the DAO")
      };
      case (?member) { 
         members.delete(p);
        return #ok();
        };
    };
  };

  // level 3 - token
  let trie = TrieMap.TrieMap<Account.Account, Nat>(Account.accountsEqual, Account.accountsHash);

  public shared query func tokenName() : async Text {
    return "SdgToken";
  };

  public shared query func symbol() : async Text {
    return "SDG";
  };

  public shared ({ caller }) func mint(to : Principal, amount : Nat) : async Result<(),Text> {
    let account : Account.Account = { owner = to; subaccount = null; };
    trie.put(account, amount);
    return #ok();
  };

  public shared ({ caller }) func transfer(from : Account.Account, to : Account.Account, amount : Nat) : async Result<(),Text> {
    let fromBalance = trie.get(from);
    switch (fromBalance){
      case (null) { 
        return #err("Sender account not found!");
      };
      case (?fromBalance) { 
        if (fromBalance < amount) {
          return #err("You have not enough tokens in your account!");
        } 
        else {
          let toBalance = trie.get(to);
          switch (toBalance){
            case (null) { 
              trie.put(to, amount);
            };
            case (?toBalance) { 
              trie.put(to, toBalance + amount);
            };
          };
          trie.put(from, fromBalance - amount);
          return #ok();
        };
      };
    };
  };

  public shared query func balanceOf(account : Account.Account) : async Nat {
    let balance = trie.get(account);
    switch (balance){
      case (null) { 
        return 0;
      };
      case (?balance) { 
        return balance;
      };
    };
  };

  public shared query func totalSupply() : async Nat {
    var total : Nat = 0;
    for (balance in trie.vals()) {
      total += balance;
    };
    return total;
  };




};
