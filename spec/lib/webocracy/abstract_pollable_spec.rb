#   Copyright (c) 2010, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.


require 'spec_helper'

module Webocracy

  describe AbstractPollable do
    before do
      # GenericProposition is GenericPollable
      @generic_pollable = FactoryGirl.build(:webocracy_generic_proposition, :author => alice.person)

      extend HelperMethods
    end

    context 'Opening & Closing' do
      it 'should be open at first' do
        @generic_pollable.closed.should == false
      end

      it 'should be closed if we close it' do
        @generic_pollable.closed = true
        @generic_pollable.closed.should == true
      end
    end

    context 'Adding Decisions' do

      describe 'General' do
        it 'must work' do
          d = new_decision 1
          @generic_pollable << d
          @generic_pollable.count.should == 1
        end

      end

      describe 'Same author' do
        before do
          @d1 = new_decision 1, bob.person
          @d2 = new_decision 0, bob.person
        end
        it 'can have multiple Decisions' do
          @generic_pollable << @d1
          @generic_pollable.count.should == 1
          @generic_pollable << @d2
          @generic_pollable.count.should == 2
        end
      end

    end

    context 'Revoking decisions' do
      before do
        @d1 = new_decision 1, bob.person
        @d2 = new_decision 0, bob.person
        @d3 = new_decision 0, bob.person
        @generic_pollable << @d1
        @generic_pollable << @d2
      end
      it 'works on all Decisions of a Citizen' do
        @generic_pollable.revoke_all_decisions_of bob.person
        @generic_pollable.count.should == 0
      end
      it 'works on a specific Decision' do
        @generic_pollable.revoke_decision @d2
        @generic_pollable.count.should == 1
        @generic_pollable.get_sum.should == 1 # result of d1
      end
      it 'does not accept Decisions from other Pollables ' do
        assert_raise InvalidDecision do
          @generic_pollable.revoke_decision @d3
        end
        assert_raise InvalidDecision do
          @generic_pollable.revoke_decision nil
        end
      end

    end


    describe '#get_last_decision_of' do
      before do
        @decision = new_decision 1
      end
      it 'must work' do
        @generic_pollable << @decision
        @generic_pollable.get_last_decision_of(@decision.author).should == @decision
      end
      it 'returns false if not found' do
        @generic_pollable << @decision
        @generic_pollable.get_last_decision_of(alice.person).should be_false
      end
    end


    describe '#count' do
      before do
        @d1 = new_decision 1, alice.person
        @d2 = new_decision 1, bob.person
        @d3 = new_decision 0, eve.person
      end
      it 'returns the number of decisions' do
        @generic_pollable.count.should == 0
        @generic_pollable << @d1
        @generic_pollable.count.should == 1
        @generic_pollable << @d2
        @generic_pollable.count.should == 2
      end
      describe 'filtering' do
        before do
          @generic_pollable << @d1
          @generic_pollable << @d2
          @generic_pollable << @d3
        end
        it 'filters by author correctly' do
          @generic_pollable.count(:author => alice.person).should == 1
          @generic_pollable.count(:author => bob.person).should == 1
          @generic_pollable.count(:author => eve.person).should == 1
          @generic_pollable.count(:author => FactoryGirl.build(:person)).should == 0
        end
        it 'filters by value correctly' do
          @generic_pollable.count(:value => 1).should == 2
          @generic_pollable.count(:value => 0).should == 1
          @generic_pollable.count(:value => -1).should == 0
        end
      end
    end


    describe '#get_sum' do
      it 'initially is 0 (without decisions)' do
        @generic_pollable.get_sum.should == 0
      end
      it 'has the value of the decision if there is only one' do
        d = new_decision 1
        @generic_pollable << d
        @generic_pollable.get_sum.should == 1
      end
      it 'holds the sum of the values of the decisions' do
        [1, 2, 3].each { |v| @generic_pollable << new_decision(v) }
        @generic_pollable.get_sum.should == 6
      end
      it 'works with negative decision values' do
        [1, 1, -3].each { |v| @generic_pollable << new_decision(v) }
        @generic_pollable.get_sum.should == -1
      end
    end

    describe '#get_mean' do
      it 'initially is 0 (without decisions)' do
        @generic_pollable.get_mean.should == 0
      end
      it 'has the value of the decision if there is only one' do
        d = new_decision 42
        @generic_pollable << d
        @generic_pollable.get_mean.should == 42
      end
      it 'holds the mean value of the values of the decisions' do
        [1, 2, 3].each { |v| @generic_pollable << new_decision(v) }
        @generic_pollable.get_mean.should == 2
      end
      it 'works with negative decision values' do
        [-5, -25, -30].each { |v| @generic_pollable << new_decision(v) }
        @generic_pollable.get_mean.should == -20
      end
      it 'works with floating results' do
        [0, 5].each { |v| @generic_pollable << new_decision(v) }
        @generic_pollable.get_mean.should == Rational(5,2)
        @generic_pollable.get_mean.should == 2.5
      end
    end

  end
end
