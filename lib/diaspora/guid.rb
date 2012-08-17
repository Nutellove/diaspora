#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

# Creates a before_create callback which calls #set_guid and makes the guid serialize in to_xml
# implicitly requires roxml
module Diaspora::Guid
  def self.included(model)
    model.class_eval do

      before_create :set_guid
      xml_attr  :guid
      validates :guid, :uniqueness => true

    end
  end

  # @return String The model's guid.
  def set_guid
    self.guid = SecureRandom.hex(8) if self.guid.blank?
  end
end
