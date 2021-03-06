#   Copyright (c) 2010, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.


require 'spec_helper'

module Webocracy

  describe Citizenable do
    before do
      extend HelperMethods
    end

    context 'Votes' do

      context 'Accessors' do
        before do
          @alices_aspect = alice.aspects.where(:name => "generic").first
          @bobs_aspect = bob.aspects.where(:name => "generic").first
          @alices_proposition = alice.post(YesNoMaybeProposition, :text => "Free the seeds", :to => @alices_aspect)
          @proposition2 = bob.post(YesNoMaybeProposition, :text => "Drop Hadopi and back Kickstarter", :to => @bobs_aspect)
          alice.vote(@alices_proposition, 1) # alice votes on her own prop
          bob.vote(@alices_proposition, 1) # bob votes on alice's prop
        end

        describe '#find_vote_for' do
          it 'returns the latest vote' do
            alices_vote = alice.find_vote_for(@alices_proposition)
            alices_vote.should_not be_nil
            alices_vote.voter.should == alice.person
            bobs_vote = bob.find_vote_for(@alices_proposition)
            bobs_vote.should_not be_nil
            bobs_vote.voter.should == bob.person
          end

          it "returns nil if there's no vote" do
            alice.find_vote_for(@proposition2).should be_nil
          end
        end

        describe '#voted_on?' do
          it "returns true if there's a vote" do
            alice.voted_on?(@alices_proposition).should be_true
            bob.voted_on?(@alices_proposition).should be_true
          end

          it "returns false if there's no vote" do
            alice.voted_on?(@proposition2).should be_false
          end
        end
      end

      context 'Propagation' do

        before do
          @alices_aspect = alice.aspects.where(:name => "generic").first
          bob.delegates << alice # bob has alice as delegate
          @alices_proposition = alice.post(YesNoMaybeProposition, :text => "Free the seeds", :to => @alices_aspect)
          alice.vote(@alices_proposition, 1) # alice decides on her own prop
          @alices_vote = alice.person.find_vote_on @alices_proposition
          eve.vote(@alices_proposition, -1) # eve decides on alice's prop
          @eves_vote = eve.person.find_vote_on @alices_proposition
        end

        it "should have alice in bob's delegates" do
          bob.delegates.should include alice.person
        end

        context 'Bob has no Vote on this Votable' do

          describe '#receives_vote!' do
            context 'of a delegate, say alice' do
              before do
                @success = bob.receives_vote! @alices_vote
                @bobs_vote = bob.find_vote_for @alices_proposition
              end
              it 'returns true' do
                @success.should be true
              end
              it 'copies the passed vote' do
                @bobs_vote.should_not be_nil
              end
              describe 'The new vote' do
                it 'has the same value' do
                  @bobs_vote.value.should == @alices_vote.value
                end
                it 'has a delegate' do
                  @bobs_vote.delegate.should == alice.person
                end
              end
            end
            context 'of somebody else, say eve' do
              before do
                bob.receives_vote! @eves_vote
                @bobs_vote = bob.find_vote_for @alices_proposition
              end
              it 'should ignore the vote' do # good enough for now, this oughta raise
                @bobs_vote.should be_nil
              end
            end
          end

        end

        context 'Bob already has a Vote on the Votable' do

          context 'and it is the same' do
            before do
              bob.vote(@alices_proposition, 1)
              @bobs_vote = bob.find_vote_for @alices_proposition
            end
            describe '#receives_vote!' do
              before do
                @success = bob.receives_vote! @alices_vote
              end
              it "returns false" do
                @success.should be false
              end
              it "does not update bob's vote" do
                bob.person.voted_as_when_voting_on(@alices_proposition).should == 1
              end
            end
          end

          context 'and it is not the same' do
            before do
              bob.vote(@alices_proposition, -1)
              @bobs_vote = bob.find_vote_for @alices_proposition
            end
            describe '#receives_vote!' do
              before do
                @success = bob.receives_vote! @alices_vote
              end
              it "returns false" do
                @success.should be false
              end
              it "does not update bob's vote" do
                bob.person.voted_as_when_voting_on(@alices_proposition).should == -1
              end
              #it notifies bob
            end
          end

        end

      end
    end

  end
end
