#   Copyright (c) 2010, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.


require 'spec_helper'

module Webocracy

  describe 'Delegation' do
    before do
      extend HelperMethods

      # create aspect 'Politics'
      @politics = alice.aspects.create(:name => 'Politics') # I18n.t('aspects.seed.politics')
      #@politics = FactoryGirl.build(:aspect, { :name => 'Politics', :user => alice })
      #alice.add_contact_to_aspect(alice.contact_for(bob.person), @politics)

      @proposition = FactoryGirl.build(:webocracy_yes_no_maybe_proposition, :author => eve.person)

    end

    describe 'Basic Operations' do

      describe 'Adding' do

        it "should not find eve in alice's delegates" do
          alice.delegates.include?(eve.person).should be_false
        end
        it "should find eve in alice's delegates after we add a Delegation" do
          delegation = alice.delegations.create(:person => eve.person)
          alice.delegates.include?(eve.person).should be_true
        end
        it "should ignore foreign delegations" do
          d = FactoryGirl.build(:webocracy_delegation, { :user => bob, :person => eve.person })
          alice.delegations << d
          alice.delegates.include?(eve.person).should be_false
        end
        it "should find eve in alice's delegates after we add her in Person" do
          alice.delegates << eve.person
          alice.delegates.include?(eve.person).should be_true
          alice.delegations.find_all{ |d| d.person == eve.person }.length.should == 1
        end
        it 'does not allow you to target yourself' do
          delegation = alice.delegations.create(:person => alice.person)
          delegation.should have(1).error_on(:person_id)
        end

      end

      describe 'Revoking' do

        it 'should work, using delegations' do
          @delegation = alice.delegations.create(:person => eve.person)
          alice.delegations.size.should == 1
          alice.delegates.size.should   == 1
          alice.delegations.delete @delegation
          alice.delegations.size.should == 0
          alice.delegates.size.should   == 0
        end

        it 'should work, using delegates' do
          alice.delegates << eve.person
          alice.delegations.size.should == 1
          alice.delegates.size.should   == 1
          alice.delegates.delete eve.person
          alice.delegations.size.should == 0
          alice.delegates.size.should   == 0
        end

      end

    end

  end
end
