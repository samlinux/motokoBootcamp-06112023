
import Buffer "mo:base/Buffer";
import Result "mo:base/Result";
import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";
import Iter "mo:base/Iter";

import TrieMap "mo:base/TrieMap";
import Nat "mo:base/Nat";
import Hash "mo:base/Hash";
import Debug "mo:base/Debug";
import List "mo:base/List";
import Int "mo:base/Int";

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


  // level 4 - voting

  // Task 1 : Define the Status and Proposal types, see account.mo for inspiration
  type Status = { #Open; #Rejected; #Accepted; };
  type Proposal = {
    id: Nat;
    status : Status;
    manifest: Text;
    votes : Int;
    voters : List.List<Principal>;
  };

  // Task 2 : Implement the proposals variable 
  var nextProposalId : Nat = 0;
  var proposals : TrieMap.TrieMap<Nat, Proposal> = TrieMap.TrieMap(Nat.equal, Hash.hash);

  // Task 3: Allow members to create proposals
  // Task 3.1: Define the createProposalOk type
  type createProposalOk = { #ProposalCreated; };

  // Task 3.2: Define the createProposalErr type
  type createProposalErr = { #NotDAOMember; #NotEnoughTokens };

  // Task 3.3: Define the createProposalResult type
  type createProposalResult = { #ok : createProposalOk; #err : createProposalErr };

  // Task 3.4: Implement the createProposal function
  public shared ({ caller }) func createProposal(manifest : Text) : async Result<createProposalOk,createProposalErr> {
    // To avoid external malicious users from creating proposals and causing confusion, 
    // you will only allow proposals to be created by members of the DAO, who own at least 1 tokens. 
    // Each proposal creation will cost 1 token and will be burned

    switch (members.get(caller)){
      case (null) { 
        return #err(#NotDAOMember);
      };
      case (?member) { 
        let account : Account.Account = { owner = caller; subaccount = null; };

        // check for enough tokens
        let balance = trie.get(account);
        Debug.print(debug_show(balance));

        switch(balance) {
          case (null) { 
            return #err(#NotEnoughTokens);
          };
          case (?balance) { 
            if(balance > 1){
              nextProposalId += 1;
              Debug.print(debug_show(nextProposalId));
              var proposal : Proposal = { 
                id = nextProposalId; 
                status = #Open; 
                manifest = manifest; 
                votes = 0; 
                voters = List.nil<Principal>(); 
                };

              proposals.put(nextProposalId, proposal);
          
              // reduce balance by 1
              trie.put(account, balance - 1);
              //return #ok( #ProposalCreated , ("ID: " #Nat.toText(nextProposalId)));
              return #ok(#ProposalCreated);
          
            } else {
              return #err(#NotEnoughTokens);
            }
          };
        }
      };
    };
  };

  // Task 4: Implement the getProposal query function
  public shared query func getProposal(id : Nat) : async ?Proposal {
    proposals.get(id);
  };

  // get_all_proposals
  public shared query func get_all_proposals() : async [(Nat, Proposal)]  {
      let result : [(Nat, Proposal)] = Iter.toArray<(Nat, Proposal)>(proposals.entries());
      result;
  };

  // Task 5: Allow members to vote on proposals
  // Task 5.1: Define the voteErr type
  type voteErr = { #AlreadyVoted; #ProposalNotFound; #ProposalEnded;}; 

  // Task 5.2: Define the voteOk type
  type voteOk = { #ProposalAccepted; #ProposalRefused; #ProposalOpen };

  // Task 5.3: Define the voteResult type
  type voteResult = { #ok : voteOk; #err : voteErr };

  // Task 5.4: Implement the vote function
  // vote : shared (id : Nat, vote : Bool) -> async VoteResult;
  public shared ({ caller }) func vote(id : Nat, vote : Bool) : async Result<voteResult, voteErr> {

    switch (members.get(caller)){
      case (null) { return #err(#ProposalEnded);};
      case (?member) { 
        let account : Account.Account = { owner = caller; subaccount = null; };

        // check if proposal exists
        var proposal = await getProposal(id);

        switch(proposal) {
          case (null) { 
            return #err(#ProposalNotFound);
          };
          case (?proposal) { 
              // check if caller has already voted
              let hasVoted : ?Principal = List.find<Principal>(proposal.voters, func x = Principal.toText(x) == Principal.toText(caller));
              switch(hasVoted) {
                case (null) { 
                  // check if proposal is still open
                  switch(proposal.status) {
                    case (#Open) { 
                      // add caller to voters
                      let voters = List.push(caller, proposal.voters);
                      
                      // with their voting power being equivalent to the number of tokens they possess
                      var balanceOfVoter = trie.get(account);
                      switch(balanceOfVoter) {
                        case (null) { 
                          return #err(#ProposalEnded);
                        };
                        case (?balanceOfVoter) { 
                          // update votes
                          var votes = proposal.votes;
                          if(vote) {
                            votes += balanceOfVoter;
                          } else {
                            votes -= balanceOfVoter;
                          };

                          var status = proposal.status;
              
                          if(votes >= 100){
                            // update proposal  
                            status := #Accepted;  
                            let updatedProposal : Proposal = { proposal with votes; voters; status; };
                            proposals.put(id, updatedProposal);

                            return #ok(#ok(#ProposalAccepted));
                          } 
                          else if (votes <= -100){
                              status := #Rejected;  
                            let updatedProposal : Proposal = { proposal with votes; voters; status; };
                            proposals.put(id, updatedProposal);
                            return #ok(#ok(#ProposalRefused));
                          } 
                          else {
                            let updatedProposal : Proposal = { proposal with votes; voters; status; };
                            proposals.put(id, updatedProposal);
                            return #ok(#ok(#ProposalOpen));
                          };
                        };
                      };
                    };
                    case (#Rejected) { 
                      return #err(#ProposalEnded);
                    };
                    case (#Accepted) { 
                      return #err(#ProposalEnded);
                    };
                  }
                };
                case (?hasVoted) { 
                  return #err(#AlreadyVoted);
                };
              }
          };
        }
      };
    };
  };


};
