#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

# A YesNo%MaybePollable entity will receive Decisions from Citizens.
# These Decisions must hold values in {-1,0,1} or an exception will be raised
module Webocracy
  module YesNoMaybePollable

    include Webocracy::AbstractPollable

    def self.included(model)
      make_pollable model
    end




    def get_winner
      mean = get_mean
      if    0 > mean; -1
      elsif 0 < mean; 1
      else; 0 end
    end

    # Make sure added decisions' values are -1, 0 or 1
    def is_valid(decision)
      [-1,0,1].include? decision.value
    end

    # Don't allow for multiple decisions
    def before_add_decision(decision)
      # replace old decision value with new one
      old_decision = get_last_decision_of decision.author
      if old_decision # we already have a Decision from this author on this pollable
        old_decision.value = decision.value
        false # don't add new
      else
        true
      end
    end

  end
end
