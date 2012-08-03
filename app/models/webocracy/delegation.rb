module Webocracy
  class Delegation < ActiveRecord::Base
    include Diaspora::HumanRelationship
  end
end