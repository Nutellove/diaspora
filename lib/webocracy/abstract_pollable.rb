#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

class Webocracy::InvalidDecision < StandardError; end

# A Pollable entity will receive Decisions from Citizens.
# It also may :
# - be open or closed
# - stay opened for a limited time (todo)
# - stay opened for a limited number of decisions (todo)
# - get syndicated data on the decisions (eg: final decision) (todo)
# - be a base for different types of polls (YesNoMaybePollable, SingleChoicePollable, MultipleChoicePollable, ValueInRangePollable) (todo)
module Webocracy
  module AbstractPollable

    def self.included(klass)
      klass.extend ClassMethods
    end

    def count(filter={})
      tmp = decisions
      if filter[:author]; tmp = tmp.find_all{|d| d.author == filter[:author]} end
      if filter[:value];  tmp = tmp.find_all{|d| d.value  == filter[:value]}  end
      tmp.length
    end

    def get_sum
      sum = 0
      return sum unless !decisions.empty?
      decisions.each do |decision|
        sum += decision.value
      end
      sum
    end

    def get_mean
      count > 0 ? get_sum.quo(count) : 0
    end

    def << (decision)
      case decision
        when Decision
          if is_valid decision
            if before_add_decision decision
              decisions << decision
            end
          else
            raise InvalidDecision, "Not valid value '#{decision.value}'"
          end
        else
          raise InvalidDecision, "Unknown decision type '#{decision.class}'"
          #raise "Unknown decision type '#{decision.class.base_class.to_s}'"
      end
    end

    # Returns advice (true/false) on if the decision may be added
    def before_add_decision(decision)
      true # todo: look @ Aquarium and AOP
    end

    # Is the passed decision a valid one ?
    # @return bool
    def is_valid(decision)
      raise InvalidDecision, "is_valid must be overridden"
    end

    def revoke_decision(decision)
      if decisions.include? decision
        decisions.delete decision
      else
        raise InvalidDecision, "Cannot revoke a foreign decision"
      end
    end

    def revoke_all_decisions_of(author)
      decisions.delete_if { |decision| author == decision.author }
    end

    def get_last_decision_of(author)
      r = false
      decisions.each do |decision|
        if author == decision.author
          r = decision
        end
      end
      r
    end

    module ClassMethods
      module ModelInstanceMethods
        #@closed = false # not working, not sure why
        def closed; true == @closed end
        def closed= status; @closed = status end
      end
      def make_pollable(model)
        # The model needs to extend ActiveRecord
        model.instance_eval do
          has_many :decisions, :class_name => 'Decision',  :dependent => :delete_all, :as => :target

          #attr_accessible :closed # not sure why this does no work... eval is evil
          include ModelInstanceMethods # using this hack instead
        end
      end
    end

  end
end
