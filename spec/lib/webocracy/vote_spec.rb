#   Copyright (c) 2010, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.


require 'spec_helper'

module Webocracy

  describe Webocracy::Vote do
    before do
      extend HelperMethods

      #@proposition = FactoryGirl.build :webocracy_yes_no_maybe_proposition
      #@proposition.save # voting requires votable id, and factories provide none
    end

    it 'has a valid factory' do
      FactoryGirl.build(:webocracy_vote).should be_valid
    end

  end
end
