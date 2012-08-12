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
          @proposition = alice.post(YesNoMaybeProposition, :text => "Free the seeds", :to => @alices_aspect)
          @proposition2 = bob.post(YesNoMaybeProposition, :text => "Drop Hadopi and back Kickstarter", :to => @bobs_aspect)
          @decision = alice.decide!(@proposition, 1) # alice decides on her own prop
          @decision2 = bob.decide!(@proposition, 1) # bob decides on alice's prop
        end

        describe '#decision_for' do
          it 'returns the correct decision' do
            alice.decision_for(@proposition).should == @decision
            bob.decision_for(@proposition).should == @decision2
          end

          it "returns nil if there's no decision" do
            alice.decision_for(@proposition2).should be_nil
          end
        end

        describe '#decided_on?' do
          it "returns true if there's a decision" do
            alice.decided_on?(@proposition).should be_true
            bob.decided_on?(@proposition).should be_true
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
          @proposition = alice.post(YesNoMaybeProposition, :text => "Free the seeds", :to => @alices_aspect)
          @alices_decision = alice.decide!(@proposition, 1) # alice decides on her own prop
        end

        context 'Bob has no Decision on this Pollable' do

          describe '#receives_decision' do
            before do
              bob.receives_decision @alices_decision
              @bobs_decision = bob.decision_for @proposition
            end
            it 'copies the passed decision' do
              @bobs_decision.should_not be_nil
            end
            it 'has the same value' do
              @bobs_decision.value.should == @alices_decision.value
            end
          end

        end

        context 'Bob already has a Decision on the Pollable' do

          context 'and it is the same' do
            before do
              @bobs_decision = bob.decide!(@proposition, 1)
            end
            describe '#receives_decision' do
              before do
                bob.receives_decision @alices_decision
                @bobs_decision_after = bob.decision_for @proposition
              end
              it "does not update bob's decision" do
                @bobs_decision_after.should == @bobs_decision
              end
            end
          end

          context 'and it is not the same' do
            before do
              @bobs_decision = bob.decide!(@proposition, -1)
            end
            describe '#receives_decision' do
              before do
                bob.receives_decision @alices_decision
                @bobs_decision_after = bob.decision_for @proposition
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
