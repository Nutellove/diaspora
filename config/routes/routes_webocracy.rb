#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.


Diaspora::Application.routes.draw do
  resources :delegations, :only => [:create, :destroy]
end
