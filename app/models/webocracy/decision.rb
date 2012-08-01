#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

# A Decision is explicitly made by a Citizen on a Pollable entity
# It holds an integer value or nil
class Webocracy::Decision < Federated::Relayable
  class Generator < Federated::Generator
    def self.federated_class
      Decision
    end

    def relayable_options
      {:target => @target, :value => nil}
    end
  end

  after_create do
    #self.parent.update_decisions_status
  end

  after_destroy do
    #self.parent.update_decisions_status
  end

  xml_attr :value

  # NOTE API V1 to be extracted
  acts_as_api
  api_accessible :backbone do |t|
    t.add :id
    t.add :guid
    t.add :author
    t.add :created_at
  end

end
