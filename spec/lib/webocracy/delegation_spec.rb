#   Copyright (c) 2010, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.


require 'spec_helper'

module Webocracy

  describe 'Delegation (fixme)' do
    before do

      # create aspect 'Politics'
      @politics = FactoryGirl.build(:aspect, { :name => 'Politics', :user => alice })

      #alice.aspects.create(:name => I18n.t('aspects.seed.politics'))
      @politics = alice.aspects.create(:name => 'Politics')
      alice.add_contact_to_aspect(alice.contact_for(bob.person), @politics)

      @proposition = FactoryGirl.build(:webocracy_yes_no_maybe_proposition, :author => eve.person)

      extend HelperMethods
    end

    describe 'Aspects' do
      it 'should find bob as alice\'s delegate' do
        # fixme
      end
    end


  end
end
