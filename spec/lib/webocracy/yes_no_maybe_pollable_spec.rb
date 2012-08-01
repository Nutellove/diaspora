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

  end
end
