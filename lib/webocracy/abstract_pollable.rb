#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

class Webocracy::InvalidDecision < StandardError; end

# A Pollable entity will receive Decisions from Citizens.
# It also may :
# - be open or closed (todo)
# - stay opened for a limited time (todo)
# - stay opened for a limited number of decisions (todo)
# - get syndicated data on the decisions (eg: final decision) (todo)
# - be a base for different types of polls (YesNoMaybePollable, SingleChoicePollable, MultipleChoicePollable, ValueInRangePollable) (todo)
module Webocracy
  module AbstractPollable

    def self.included(klass)
      klass.extend ClassMethods
    end

    def count
      decisions.length
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
      count > 0 ? get_sum / count : get_sum
    end

    def << (decision)
      case decision
        when Decision
          if is_valid decision
            old_decision = get_decision_from decision.author
            if old_decision
              old_decision.value = decision.value
            else
              self.decisions << decision
            end
          else
            raise InvalidDecision, "Not valid value '#{decision.value}'"
          end
        else
          raise InvalidDecision, "Unknown decision type '#{decision.class}'"
          #raise "Unknown decision type '#{decision.class.base_class.to_s}'"
      end
    end

    # Is the passed decision a valid one ?
    # @return bool
    def is_valid(decision)
      raise InvalidDecision, "is_valid must be overridden"
    end

    def get_decision_from(author)
      r = false
      decisions.each do |decision|
        if author == decision.author
          r = decision
        end
      end
      r
    end

    module ClassMethods
      def make_pollable(model)
        # The model needs to extend ActiveRecord
        model.instance_eval do
          has_many :decisions, :class_name => 'Decision',  :dependent => :delete_all, :as => :target
        end
      end
    end

  end
end
