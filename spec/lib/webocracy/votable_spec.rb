#   Copyright (c) 2010, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.


require 'spec_helper'

module Webocracy

  describe 'Implementation of acts_as_votable' do
    before do
      extend HelperMethods

      @proposition = FactoryGirl.build :webocracy_yes_no_maybe_proposition
      @proposition.save # voting requires votable id, and factories provide none
    end

    describe 'Proposition' do

      it 'acts as votable' do
        AbstractProposition.should   be_votable
        GenericProposition.should    be_votable
        YesNoMaybeProposition.should be_votable
      end

    end

    describe 'Votable' do

      it 'can be voted on by a person' do
        @proposition.vote :voter => alice.person, :value => 1
        @proposition.votes.should have(1).vote
      end

      it 'can be voted on by different persons' do
        @proposition.vote :voter => alice.person, :value => 1
        @proposition.vote :voter => bob.person,   :value => 1
        @proposition.votes.should have(2).vote
      end

    end

    describe 'Voter' do

      it 'can vote' do
        @proposition.vote :voter => alice.person, :value => 1
        @proposition.votes.should have(1).vote
      end

      it 'can update vote value by voting again' do
        @proposition.vote :voter => alice.person, :value => -1
        @proposition.vote :voter => alice.person, :value => 1
        @proposition.votes.should have(1).vote
        @proposition.votes.valued(-1).should have(0).vote
        @proposition.votes.valued(1).should have(1).vote
      end

    end

    describe 'Vote' do

      it 'todo' do

        

      end

    end

  end
end
