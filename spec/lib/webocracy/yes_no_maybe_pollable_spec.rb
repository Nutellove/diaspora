#   Copyright (c) 2010, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

require 'spec_helper'

module Webocracy
  describe YesNoMaybePollable do
    before do
      @ynm_pollable = FactoryGirl.build(:webocracy_yes_no_maybe_proposition, :author => alice.person)
    end

    describe '#is_valid' do
      it 'should accept Decisions with values in {-1,0,1}' do
        d1 = Decision.new({:value => -1})
        d2 = Decision.new({:value => 0})
        d3 = Decision.new({:value => 1})
        @ynm_pollable << d1
        @ynm_pollable << d2
        @ynm_pollable << d3
      end
      it 'should not accept Decisions with values outside {-1,0,1}' do
        assert_raise InvalidDecision do
          d1 = Decision.new({:value => 2})
          @ynm_pollable << d1
        end
        assert_raise InvalidDecision do
          d1 = Decision.new({:value => -2})
          @ynm_pollable << d1
        end
      end
    end

  end
end
