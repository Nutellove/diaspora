#   Copyright (c) 2010, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.


require 'spec_helper'

module Webocracy

  describe 'Delegation' do
    before do
      extend HelperMethods
      # create aspect 'Politics'
      #@politics = alice.aspects.create(:name => 'Politics') # I18n.t('aspects.seed.politics')
      #@politics = FactoryGirl.build(:aspect, { :name => 'Politics', :user => alice })
      #alice.add_contact_to_aspect(alice.contact_for(bob.person), @politics)
    end

    it 'has a valid factory' do
      FactoryGirl.build(:webocracy_delegation).should be_valid
    end

    describe 'Basic Operations' do

      describe 'Adding' do

        it "should not find eve in alice's delegates" do
          alice.delegates.should_not include eve.person
        end
        it "should find eve in alice's delegates after we create a Delegation" do
          alice.delegations.create(:person => eve.person)
          alice.delegates.should include eve.person
        end
        it "should find eve in alice's delegates after we build a Delegation" do
          d = FactoryGirl.build(:webocracy_delegation, { :user => alice, :person => eve.person })
          alice.delegations << d
          alice.delegates.should include eve.person
        end
        it "should ignore foreign delegations" do
          d = FactoryGirl.build(:webocracy_delegation, { :user => bob, :person => eve.person })
          alice.delegations << d
          alice.delegates.should_not include eve.person
        end
        it "should find eve in alice's delegates after we add her in Person" do
          alice.delegates << eve.person
          alice.delegates.should include eve.person
          alice.delegations.find_all{ |d| d.person == eve.person }.length.should == 1
        end
        it 'does not allow you to target yourself' do
          delegation = alice.delegations.create(:person => alice.person)
          delegation.should have(1).error_on(:person_id)
          alice.delegations << delegation # another way
          alice.delegates.should_not include alice.person
          alice.delegates << alice # another way
          alice.delegates.should_not include alice.person
        end

        describe '#user.delegations.<<' do

          it 'allows Users' do
            alice.delegations << eve
            alice.delegates.should include eve.person
          end

          it 'allows Persons' do
            alice.delegations << eve.person
            alice.delegates.should include eve.person
          end

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


    describe 'Decision Propagation' do

      before do
        @eves_proposition = FactoryGirl.build(:webocracy_yes_no_maybe_proposition, :author => eve.person)
        alice.delegates << bob.person
      end

      describe 'Workflow' do

        it 'test' do



        end

        it 'propagates decisions to comrades' do
          #pending "Thinking..."
          #d = new_decision 1, bob.person
          #@proposition << d
          #puts d.inspect
          #puts @proposition.decisions.first.inspect
        end

      end

    end

  end
end
