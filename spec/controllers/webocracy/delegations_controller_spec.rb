require 'spec_helper'

describe DelegationsController do
  before do
    sign_in alice
  end

  describe "#create" do
    it "creates a delegation on specified person" do
      expect {
        post :create, :delegation => {:person_id => eve.person.id}
      }.should change { alice.delegations.count }.by(1)
    end

    it "redirects back for html" do
      post :create, :delegation => { :person_id => eve.person.id }
      response.should be_redirect
    end

    it "sends a 204 for json" do
      post :create, :delegation => { :person_id => eve.person.id }, :format => :json
      response.status.should == 204
    end

    it "notifies the user" do
      post :create, :delegation => { :person_id => eve.person.id }
      flash.should_not be_empty
    end

  end

  describe "#destroy" do
    before do
      @delegation = alice.delegations.create(:person => eve.person)
    end

    it "redirects back for html" do
      delete :destroy, :id => @delegation.id
      response.should be_redirect
    end

    it "sends a 204 for json" do
      delete :destroy, :id => @delegation.id, :format => :json
      response.status.should == 204
    end

    it "removes a delegation" do
      expect {
        delete :destroy, :id => @delegation.id
      }.should change { alice.delegations.count }.by(-1)
    end
  end

end
