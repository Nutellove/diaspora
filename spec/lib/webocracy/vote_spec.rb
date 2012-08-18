#   Copyright (c) 2010, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.


require 'spec_helper'

module Webocracy

  describe Webocracy::Vote do
    before do
      extend HelperMethods

      @proposition = FactoryGirl.build :webocracy_yes_no_maybe_proposition
      @proposition.save # voting requires votable id, and factories provide none
    end

    it 'has a valid factory' do
      FactoryGirl.build(:webocracy_vote).should be_valid
    end

    describe 'Usage in acts_as_votable' do

      it 'should be the class used for votes' do
        alice.vote @proposition, 1
        alice.person.votes.first.should be_a Webocracy::Vote
        @proposition.votes.first.should be_a Webocracy::Vote
      end

    end

  end
end
