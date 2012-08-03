#   Copyright (c) 2010, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.


require 'spec_helper'

module Webocracy

  describe 'Delegation (fixme)' do
    before do
      extend HelperMethods

      #@politics = FactoryGirl.build(:aspect, { :name => 'Politics', :user => alice })

      # create aspect 'Politics'
      @politics = alice.aspects.create(:name => 'Politics') # I18n.t('aspects.seed.politics')
      alice.add_contact_to_aspect(alice.contact_for(bob.person), @politics)

      @proposition = FactoryGirl.build(:webocracy_yes_no_maybe_proposition, :author => eve.person)

    end

    describe 'Aspects' do
      it "should find bob in alice's delegates" do
        alice.delegates.include?(bob.person).should be_true
      end
      it "should not find eve in alice's delegates" do
        alice.delegates.include?(eve.person).should be_false
      end
      it "should find eve in alice's delegates after we add her" do
        pending "thinking about user aspects, maybe we need system aspects"
        alice.delegates << eve.person
        alice.delegates.include?(eve.person).should be_true
      end
    end


  end
end
