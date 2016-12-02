require "rails_helper"

describe User do
  describe ".import" do
    it "should create a user from data from copro" do
      User.import_model({ uid: 1, screen_name: "niuage" })

      user = User.last
      expect(user.uid).to eq 1
      expect(user.screen_name).to eq "niuage"
    end

    it "should update a user from data from copro" do
      User.create(uid: 1, screen_name: "niuage")

      User.import_model({
        uid: 1,
        screen_name: "hello"
      })

      expect(User.count).to eq 1

      user = User.last
      expect(user.uid).to eq 1
      expect(user.screen_name).to eq "hello"
    end
  end
end
