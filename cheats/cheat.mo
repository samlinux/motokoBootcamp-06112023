/**
 * some Result adventure
 */

import Result "mo:base/Result";
import Text "mo:base/Text";
import Nat8 "mo:base/Nat8";
import Buffer "mo:base/Buffer";
import Bool "mo:base/Bool";

actor {

  stable var nameStore : Text = "";
  
  public query func getName(name:Text) : async Result.Result<Text, Text> {
    if(name == "John") {
      #ok("John");
    } else {
      #err("Not John");
    }
  };

  public query func getName2(name:Text) : async Result.Result<(), Text> {
    if(name == "John") {
      #ok();
    } else {
       #err("Not John");
    }
  };

  type myErr = { #NotFound; #NotJohn; }; 

  public query func getName3(name:Text) : async Result.Result<(), myErr> {
    if(name == "John") {
      #ok();
    } 
    else if(name == ""){
      #err(#NotFound);
    }
    else {
      #err(#NotJohn);
    }
  };

  type myOk = { #IsJohn; };
  public query func getName4(name:Text) : async Result.Result<myOk, myErr> {
    if(name == "John") {
       #ok(#IsJohn);
    } 
    else {
      #err(#NotJohn);
    }
  };

  type myErr2 = { #NameEmpty; }; 
  public func setName(name:Text) : async Result.Result<(), myErr2> {
    if(name == "") {
      #err(#NameEmpty);
    } 
    else {
      nameStore := name;
      #ok();
    }
  
  };

  public query func getName5() : async Result.Result<Text, myErr2> {
    if(nameStore == "") {
      #err(#NameEmpty);
    } 
    else {
      #ok(nameStore);
    }
  };

  // return a #ok Result as variant with text
  public query func getName6() : async Result.Result<{ok: Text}, Text> {
    if(nameStore == "") {
      #err("NameEmpty");
    } 
    else {
      #ok({ok = "Test"});
    }
  };

  type Person = { name: Text; age: Nat8;};
  public query func getName7() : async Result.Result<{ok: Person}, Text> {
    let p : Person = { name = "John"; age = 42; };
    #ok({ok = p});
  };

  public query func getName8() : async Result.Result<{ok: [Text]}, Text> {
    var goals : Buffer.Buffer<Text> = Buffer.Buffer<Text>(1);
    goals.add("Goal1");
    goals.add("Goal2");

    #ok({ok = Buffer.toArray(goals);});
  };

  // return a #ok Result with ID
  type myOkRecordStatus = { #inserted; #updated;};
  type myOkRecord = { id : Nat; status : myOkRecordStatus};
  public query func getName9() : async Result.Result<{ok: myOkRecord}, Text> {
    #ok({ok = {id = 42; status = #inserted}});
  };

  type insertOk = { insertedId : Nat; };
  type insertErr = { #insertedFailed; };

  public query func insert(status:Bool) : async Result.Result<insertOk, insertErr> {
    if(status) {
      #ok({insertedId = 42});
    } else {
      #err(#insertedFailed);
    } 
  };

  type updateErr = { #updateFailed; };
  public query func update(status:Bool) : async Result.Result<(), updateErr> {
    if(status) {
      #ok();
    } else {
      #err(#updateFailed);
    } 
  };

  type Member = { id : Nat; name : Text; country : Text; };
  type recordNotFound = { #recordNotFound; };
  type getRecordOk = { data : Member; };
  type getRecordErr = { id : Nat; err : recordNotFound;};
  public query func getRecord(status:Bool) : async Result.Result<getRecordOk, getRecordErr> {
    if(status) {
      let m : Member = { id = 42; name = "John"; country = "USA"; };
      #ok({data = m});
    } else {
      #err({id = 43; err = #recordNotFound});
    } 
  };

  // return an object array 
  type getRecordsOk = { data : [Member]; };
  type getRecordsErr = { #noRecords; };
  public query func getRecords(status:Bool) : async Result.Result<getRecordsOk, getRecordsErr> {
    if(status) {
      let m1 : Member = { id = 42; name = "John"; country = "USA"; };
      let m2 : Member = { id = 43; name = "Jane"; country = "USA"; };
      #ok({data = [m1, m2]});
    } else {
      #err(#noRecords);
    } 
  };

  // return recors as array with total count
  type getRecordsWithCountOk = { data : [Member]; count : Nat; };
  type getRecordsWithCountErr = { #noRecords; };
  public query func getRecordsWithCount(status:Bool) : async Result.Result<getRecordsWithCountOk, getRecordsWithCountErr> {
    if(status) {
      let m1 : Member = { id = 42; name = "John"; country = "USA"; };
      let m2 : Member = { id = 43; name = "Jane"; country = "USA"; };
      let data : [Member] = [m1, m2];
      #ok({data = data; count = data.size()});
    } else {
      #err(#noRecords);
    } 
  };


}