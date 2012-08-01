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


    # Make sure added decisions' values are -1, 0 or 1
    def is_valid(decision)
      [-1,0,1].include? decision.value
    end

    def get_winner
      mean = get_mean
      if    0 > mean; -1
      elsif 0 < mean; 1
      else; 0 end
    end

  end
end
