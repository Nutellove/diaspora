require 'spec_helper'

describe VotesController do
  before do
    extend Webocracy::HelperMethods
    sign_in alice

    @proposition = FactoryGirl.build :webocracy_yes_no_maybe_proposition
    @proposition.save # voting requires votable id, and factories provide none
  end

  describe "#create" do
    it "creates a vote on specified proposition" do
      expect {
        post :create, :vote => {:proposition_id => @proposition.id}
      }.should change { alice.votes.count }.by(1)
    end

    it "redirects back for html" do
      post :create, :vote => {:proposition_id => @proposition.id}
      response.should be_redirect
    end

    it "sends a 204 for json" do
      post :create, :vote => {:proposition_id => @proposition.id}, :format => :json
      response.status.should == 204
    end

    #it "notifies the user" do
    #  post :create, :vote => {:proposition_id => @proposition.id}
    #  flash.should_not be_empty
    #end

  end

  describe "#destroy" do
    before do
      @vote = alice.votes.create(:votable => @proposition, :value => 1)
    end

    it "redirects back for html" do
      delete :destroy, :id => @vote.id
      response.should be_redirect
    end

    it "sends a 204 for json" do
      delete :destroy, :id => @vote.id, :format => :json
      response.status.should == 204
    end

    it "removes a vote by its id" do
      expect {
        delete :destroy, :id => @vote.id
      }.should change { alice.votes.count }.by(-1)
    end

    it "removes all votes on votable" do
      expect {
        delete :destroy, :votable_id => @votable.id
      }.should change { alice.votes.count }.by(-1)
    end
  end

end
