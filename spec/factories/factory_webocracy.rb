#   Copyright (c) 2010-2011, Diaspora In  This file is
#   licensed under the Affero General Public License version 3 or late  See
#   the COPYRIGHT file.

#For Guidance
#http://github.com/thoughtbot/factory_girl
# http://railscasts.com/episodes/158-factories-not-fixtures

FactoryGirl.define do

  factory :webocracy_generic_proposition, :class => Webocracy::GenericProposition do
    sequence(:text) { |n| "Generic Propal #{n}" }
    association :author, :factory => :person
    after_build do |prop|
      prop.diaspora_handle = prop.author.diaspora_handle
    end
  end

  factory :webocracy_yes_no_maybe_proposition, :class => Webocracy::YesNoMaybeProposition do
    sequence(:text) { |n| "YNM Propal #{n}" }
    association :author, :factory => :person
    after_build do |prop|
      prop.diaspora_handle = prop.author.diaspora_handle
    end
  end

  #factory :decision do
  #  association :author, :factory => :person
  #  association :target, :factory => :proposition
  #end


end
