#   Copyright (c) 2010, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

require 'spec_helper'

module Webocracy
  describe YesNoMaybePollable do
    before do
      @ynm_pollable = FactoryGirl.build(:webocracy_yes_no_maybe_proposition, :author => alice.person)
      extend HelperMethods
    end

    describe '#is_valid' do
      it 'should accept Decisions with values in {-1,0,1}' do
        [-1, 0, 1].each { |v| @ynm_pollable << new_decision(v) }
        @ynm_pollable.count.should == 3
      end
      it 'should not accept Decisions with values outside {-1,0,1}' do
        assert_raise InvalidDecision do
          d1 = new_decision 2
          @ynm_pollable << d1
        end
        assert_raise InvalidDecision do
          d1 = new_decision -2
          @ynm_pollable << d1
        end
      end
    end

    describe '#get_winner' do
      it 'should return 0 initially' do
        [1,0,-1].each { |v| @ynm_pollable << new_decision(v) }
        @ynm_pollable.get_winner.should == 0
      end
      it 'should return the value for a single Decision' do
        [1].each { |v| @ynm_pollable << new_decision(v) }
        @ynm_pollable.get_winner.should == 1
      end
      it 'should return a value in {-1,0,1}' do
        [1,1,0,-1].each { |v| @ynm_pollable << new_decision(v) }
        @ynm_pollable.get_winner.should == 1
      end
      it 'should return 0 in case of a draw' do
        [1,-1].each { |v| @ynm_pollable << new_decision(v) }
        @ynm_pollable.get_winner.should == 0
      end
    end

  end
end
