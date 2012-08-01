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

    describe '#get_sum' do
      it 'initially is 0 (without decisions)' do
        @generic_pollable.get_sum.should == 0
      end
      it 'has the value of the decision if there is only one' do
        d = Decision.new({:value => 1})
        @generic_pollable << d
        @generic_pollable.get_sum.should == 1
      end
      it 'holds the sum of the values of the decisions' do
        d1 = Decision.new({:value => 1})
        d2 = Decision.new({:value => 2})
        d3 = Decision.new({:value => 3})
        @generic_pollable << d1
        @generic_pollable << d2
        @generic_pollable << d3
        @generic_pollable.get_sum.should == 6
      end
      it 'works with negative decision values' do
        d1 = Decision.new({:value => 1})
        d2 = Decision.new({:value => 1})
        d3 = Decision.new({:value => -3})
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
        d = Decision.new({:value => 42})
        @generic_pollable << d
        @generic_pollable.get_mean.should == 42
      end
      it 'holds the mean value of the values of the decisions' do
        d1 = Decision.new({:value => 1})
        d2 = Decision.new({:value => 2})
        d3 = Decision.new({:value => 3})
        @generic_pollable << d1
        @generic_pollable << d2
        @generic_pollable << d3
        @generic_pollable.get_mean.should == 2
      end
      it 'works with negative decision values' do
        d1 = Decision.new({:value => -5})
        d2 = Decision.new({:value => -25})
        d3 = Decision.new({:value => -30})
        @generic_pollable << d1
        @generic_pollable << d2
        @generic_pollable << d3
        @generic_pollable.get_mean.should == -20
      end
    end


  end
end
