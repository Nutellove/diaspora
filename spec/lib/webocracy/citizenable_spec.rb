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
          bob.vote(@alices_proposition, 1)   # bob votes on alice's prop
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

          it "returns false if there's no decision" do
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

        #describe DecisionFetcher do
        #
        #  describe '#get_from' do
        #    it 'gets the decisions of the local person' do
        #      DecisionFetcher.get_from(alice.person).should include @alices_decision
        #      DecisionFetcher.get_from(alice.person).should_not include @eves_decision
        #      DecisionFetcher.get_from(bob.person).count.should == 0
        #    end
        #  end
        #
        #  describe '#get_from_delegates_of' do
        #    context 'without options' do
        #      it 'gets the non-conflicting decisions of the delegates' do
        #        DecisionFetcher.get_from_delegates_of(bob.person).should include @alices_decision
        #        DecisionFetcher.get_from_delegates_of(bob.person).count.should == 1
        #      end
        #    end
        #  end
        #
        #end


        context 'Bob has no Decision on this Pollable' do

          describe '#receives_vote!' do
            context 'of a delegate, say alice' do
              before do
                bob.receives_vote! @alices_decision
                @bobs_vote = bob.find_vote_for @alices_proposition
              end
              it 'copies the passed decision' do
                @bobs_vote.should_not be_nil
              end
              it 'has the same value' do
                @bobs_vote.value.should == @alices_decision.value
              end
            end
            context 'of somebody else, say eve' do
              before do
                bob.receives_vote! @eves_decision
                @bobs_vote = bob.find_vote_for @alices_proposition
              end
              it 'should ignore the decision' do # good enough for now, this oughta raise
                @bobs_vote.should be_nil
              end
            end
          end

        end

        context 'Bob already has a Decision on the Pollable' do

          context 'and it is the same' do
            before do
              @bobs_vote = bob.vote(@alices_proposition, 1)
            end
            describe '#receives_vote!' do
              before do
                bob.receives_vote! @alices_decision
                @bobs_vote_after = bob.find_vote_for @alices_proposition
              end
              it "does not update bob's decision" do
                @bobs_vote_after.should == @bobs_vote
              end
            end
          end

          context 'and it is not the same' do
            before do
              @bobs_vote = bob.vote(@alices_proposition, -1)
            end
            describe '#receives_vote!' do
              before do
                bob.receives_vote! @alices_decision
                @bobs_vote_after = bob.find_vote_for @alices_proposition
              end
              it "does not update bob's decision" do
                @bobs_vote_after.should == @bobs_vote
              end
              #it notifies bob
            end
          end

        end

      end
    end

  end
end
