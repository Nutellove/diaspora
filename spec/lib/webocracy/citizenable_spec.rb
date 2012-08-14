#   Copyright (c) 2010, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.


require 'spec_helper'

module Webocracy

  describe Citizenable do
    before do
      extend HelperMethods
    end

    context 'Decisions' do

      context 'Accessors' do
        before do
          @alices_aspect = alice.aspects.where(:name => "generic").first
          @bobs_aspect = bob.aspects.where(:name => "generic").first
          @alices_proposition = alice.post(YesNoMaybeProposition, :text => "Free the seeds", :to => @alices_aspect)
          @proposition2 = bob.post(YesNoMaybeProposition, :text => "Drop Hadopi and back Kickstarter", :to => @bobs_aspect)
          @alices_decision = alice.decide!(@alices_proposition, 1) # alice decides on her own prop
          @bobs_decision = bob.decide!(@alices_proposition, 1) # bob decides on alice's prop
        end

        describe '#decision_for' do
          it 'returns the correct decision' do
            alice.decision_for(@alices_proposition).should == @alices_decision
            bob.decision_for(@alices_proposition).should == @bobs_decision
          end

          it "returns nil if there's no decision" do
            alice.decision_for(@proposition2).should be_nil
          end
        end

        describe '#decided_on?' do
          it "returns true if there's a decision" do
            alice.decided_on?(@alices_proposition).should be_true
            bob.decided_on?(@alices_proposition).should be_true
          end

          it "returns false if there's no decision" do
            alice.decided_on?(@proposition2).should be_false
          end
        end
      end

      context 'Propagation' do

        before do
          @alices_aspect = alice.aspects.where(:name => "generic").first
          bob.delegates << alice # bob has alice as delegate
          @alices_proposition = alice.post(YesNoMaybeProposition, :text => "Free the seeds", :to => @alices_aspect)
          @alices_decision = alice.decide!(@alices_proposition, 1) # alice decides on her own prop
          @eves_decision = eve.decide!(@alices_proposition, -1) # eve decides on alice's prop
        end

        it "should have alice in bob's delegates" do
          bob.delegates.should include alice.person
        end

        context 'Bob has no Decision on this Pollable' do

          describe '#receives_decision!' do
            context 'of a delegate, say alice' do
              before do
                bob.receives_decision! @alices_decision
                @bobs_decision = bob.decision_for @alices_proposition
              end
              it 'copies the passed decision' do
                @bobs_decision.should_not be_nil
              end
              it 'has the same value' do
                @bobs_decision.value.should == @alices_decision.value
              end
            end
            context 'of somebody else, say eve' do
              before do
                bob.receives_decision! @eves_decision
                @bobs_decision = bob.decision_for @alices_proposition
              end
              it 'should ignore the decision' do # good enough for now, this oughta raise
                @bobs_decision.should be_nil
              end
            end
          end

        end

        context 'Bob already has a Decision on the Pollable' do

          context 'and it is the same' do
            before do
              @bobs_decision = bob.decide!(@alices_proposition, 1)
            end
            describe '#receives_decision!' do
              before do
                bob.receives_decision! @alices_decision
                @bobs_decision_after = bob.decision_for @alices_proposition
              end
              it "does not update bob's decision" do
                @bobs_decision_after.should == @bobs_decision
              end
            end
          end

          context 'and it is not the same' do
            before do
              @bobs_decision = bob.decide!(@alices_proposition, -1)
            end
            describe '#receives_decision!' do
              before do
                bob.receives_decision! @alices_decision
                @bobs_decision_after = bob.decision_for @alices_proposition
              end
              it "does not update bob's decision" do
                @bobs_decision_after.should == @bobs_decision
              end
              #it notifies bob
            end
          end

        end

      end
    end

  end
end
