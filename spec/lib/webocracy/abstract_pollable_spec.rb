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


    describe '#<< (adding a decision)' do

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

        it 'can only have one Decision per Citizen' do
          @generic_pollable << @d1
          @generic_pollable.count.should == 1
          @generic_pollable << @d2
          @generic_pollable.count.should == 1
        end

        it 'updates the old decision value' do # may replace the decision altogether later on (for timestamps, etc)
          @generic_pollable << @d1
          @generic_pollable.get_sum.should == 1
          @generic_pollable << @d2
          @generic_pollable.get_sum.should == 0
        end
      end

    end


    describe '#get_decision_from' do
      before do
        @decision = new_decision 1
      end
      it 'must work' do
        @generic_pollable << @decision
        @generic_pollable.get_decision_from(@decision.author).should == @decision
      end
      it 'returns false if not found' do
        @generic_pollable << @decision
        @generic_pollable.get_decision_from(alice.person).should be_false
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
    end

  end
end
