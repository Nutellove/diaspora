#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

# Basically, a Post that is Pollable
# This is an abstract class
class Webocracy::AbstractProposition < Post

  self.abstract_class = true

  attr_accessible :closed

  acts_as_votable :class => Webocracy::Vote

end
