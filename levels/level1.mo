import Buffer "mo:base/Buffer";

actor {
  // Task 1: Define a name for you DAO
  let name : Text = "SDG-DAO";

  // Task 2: Define a manifesto for you DAO
  private var manifesto : Text = "DEMO for the MotokoBootcamp";

  // Task 3: Implement the getName query function
  public shared query func getName() : async Text {
    return name;
  };

  // Task 4: Implement the getManifesto query function
  public shared query func getManifesto() : async Text {
    return manifesto;
  };

  // Task 5: Implement the setManifesto update function
  public shared func setManifesto(newManifesto : Text) : async () {
    manifesto := newManifesto;
  };

  // Task 6: Define a list of goals for your DAO
  let goals = Buffer.Buffer<Text>(10);

  // Task 7: Implement the addGoal function
  public shared func addGoal(goal : Text) : async () {
    goals.add(goal);
  };

  // Task 8: Implement the getGoals query function
  public shared query func getGoals() : async [Text] {
    return Buffer.toArray(goals);
  };


};
