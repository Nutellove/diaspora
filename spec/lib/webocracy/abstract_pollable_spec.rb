#   Copyright (c) 2010, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.


require 'spec_helper'

module Webocracy
  describe AbstractPollable do
    before do

      # GenericProposition is GenericPollable
      @generic_pollable = FactoryGirl.build(:webocracy_generic_proposition, :author => alice.person)


    end

    describe '<< (adding decisions)' do
      it 'must work' do
        d = FactoryGirl.build(:webocracy_decision, :value => 1)
        @generic_pollable << d
        @generic_pollable.count.should == 1
      end

      it 'can only have one Decision per Citizen' do
        d1 = FactoryGirl.build(:webocracy_decision, {:value => 1, :author => bob.person})
        d2 = FactoryGirl.build(:webocracy_decision, {:value => 0, :author => bob.person})
        @generic_pollable << d1
        @generic_pollable << d2
        @generic_pollable.count.should == 1
      end
    end


    describe '#get_decision_from' do
      it 'must work' do
        d = FactoryGirl.build(:webocracy_decision, :value => 1)
        @generic_pollable << d
        @generic_pollable.get_decision_from(d.author).should == d
      end
      it 'returns false if not found' do
        d = FactoryGirl.build(:webocracy_decision, :value => 1)
        @generic_pollable << d
        @generic_pollable.get_decision_from(alice.person).should be_false
      end
    end


    describe '#get_sum' do
      it 'initially is 0 (without decisions)' do
        @generic_pollable.get_sum.should == 0
      end
      it 'has the value of the decision if there is only one' do
        d = FactoryGirl.build(:webocracy_decision, :value => 1)
        @generic_pollable << d
        @generic_pollable.get_sum.should == 1
      end
      it 'holds the sum of the values of the decisions' do
        d1 = FactoryGirl.build(:webocracy_decision, :value => 1)
        d2 = FactoryGirl.build(:webocracy_decision, :value => 2)
        d3 = FactoryGirl.build(:webocracy_decision, :value => 3)
        @generic_pollable << d1
        @generic_pollable << d2
        @generic_pollable << d3
        @generic_pollable.get_sum.should == 6
      end
      it 'works with negative decision values' do
        d1 = FactoryGirl.build(:webocracy_decision, :value => 1)
        d2 = FactoryGirl.build(:webocracy_decision, :value => 1)
        d3 = FactoryGirl.build(:webocracy_decision, :value => -3)
        @generic_pollable << d1
        @generic_pollable << d2
        @generic_pollable << d3
        @generic_pollable.get_sum.should == -1
      end
    end

    describe '#get_mean' do
      it 'initially is 0 (without decisions)' do
        @generic_pollable.get_mean.should == 0
      end
      it 'has the value of the decision if there is only one' do
        d = FactoryGirl.build(:webocracy_decision, :value => 42)
        @generic_pollable << d
        @generic_pollable.get_mean.should == 42
      end
      it 'holds the mean value of the values of the decisions' do
        d1 = FactoryGirl.build(:webocracy_decision, :value => 1)
        d2 = FactoryGirl.build(:webocracy_decision, :value => 2)
        d3 = FactoryGirl.build(:webocracy_decision, :value => 3)
        @generic_pollable << d1
        @generic_pollable << d2
        @generic_pollable << d3
        @generic_pollable.get_mean.should == 2
      end
      it 'works with negative decision values' do
        d1 = FactoryGirl.build(:webocracy_decision, :value => -5)
        d2 = FactoryGirl.build(:webocracy_decision, :value => -25)
        d3 = FactoryGirl.build(:webocracy_decision, :value => -30)
        @generic_pollable << d1
        @generic_pollable << d2
        @generic_pollable << d3
        @generic_pollable.get_mean.should == -20
      end
    end

  end
end
