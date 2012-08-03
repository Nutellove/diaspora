#   Copyright (c) 2010, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.


require 'spec_helper'

module Webocracy

  describe 'Delegation (fixme)' do
    before do
      extend HelperMethods

      # create aspect 'Politics'
      @politics = alice.aspects.create(:name => 'Politics') # I18n.t('aspects.seed.politics')
      #@politics = FactoryGirl.build(:aspect, { :name => 'Politics', :user => alice })
      #alice.add_contact_to_aspect(alice.contact_for(bob.person), @politics)

      @proposition = FactoryGirl.build(:webocracy_yes_no_maybe_proposition, :author => eve.person)

    end

    describe 'Delegation' do
      it "should not find eve in alice's delegates" do
        alice.delegates.include?(eve.person).should be_false
      end
      it "should find eve in alice's delegates after we add a Delegation" do
        d = FactoryGirl.build(:webocracy_delegation, { :user => alice, :person => eve.person })
        alice.delegations << d
        alice.delegates.include?(eve.person).should be_true
      end
      it "should find eve in alice's delegates after we add a Person" do
        alice.delegates << eve.person
        alice.delegates.include?(eve.person).should be_true
      end
    end

  end
end
