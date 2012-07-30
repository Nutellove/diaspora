#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

# A Pollable entity will receive Decisions from Citizens.
# It also may :
# - be open or closed (todo)
# - stay opened for a limited time (todo)
# - stay opened for a limited number of decisions (todo)
# - get syndicated data on the decisions (eg: final decision) (todo)
module Webocracy
  module Pollable
    def self.included(model)
      model.instance_eval do
        has_many :decisions, :class_name => 'Decision',  :dependent => :delete_all, :as => :target
      end
    end
  end
end
