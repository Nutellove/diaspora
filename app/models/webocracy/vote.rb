#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

# A Decision is explicitly made by a Citizen on a Pollable entity
# It holds an integer value
module Webocracy
  class Vote < ActiveRecord::Base

    include ActsAsVotable::VoteBehavior

    attr_accessible :delegate, :delegate_id, :delegate_type

    belongs_to :delegate, :polymorphic => true




  end
end
