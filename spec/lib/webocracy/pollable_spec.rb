#   Copyright (c) 2010, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

require 'spec_helper'

describe Webocracy::Pollable do
  before do
    # Proposition is Pollable
    @proposition = Factory(:proposition, :author => alice.person)
  end

  describe '#decisions_sum' do
    it 'initially is 0 (without decisions)' do
      @proposition.get_sum.should == 0
    end
    it 'has the value of the decision if there is only one' do
      d = Decision.new({ :value => 1 })
      @proposition.decisions << d
      @proposition.get_sum.should == 1
    end
    it 'holds the sum of the values of the decisions' do
      d1 = Decision.new({ :value => 1 })
      d2 = Decision.new({ :value => 2 })
      d3 = Decision.new({ :value => 3 })
      @proposition.decisions << d1
      @proposition.decisions << d2
      @proposition.decisions << d3
      @proposition.get_sum.should == 6
    end
    it 'works with negative decision values' do
      d1 = Decision.new({ :value => 1 })
      d2 = Decision.new({ :value => 1 })
      d3 = Decision.new({ :value => -3 })
      @proposition.decisions << d1
      @proposition.decisions << d2
      @proposition.decisions << d3
      @proposition.get_sum.should == -1
    end
  end
end
