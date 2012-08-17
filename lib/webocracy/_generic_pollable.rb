#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

# A GenericPollable entity will receive Decisions with any values from Citizens.
module Webocracy
  module GenericPollable
    include Webocracy::AbstractPollable

    def self.included(model)
      make_pollable model
    end

    def is_valid(decision)
      true # model makes sure value is already an integer
    end

    def before_add_decision(decision)
      true # yay, add as much as you want
    end
  end
end
