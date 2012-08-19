class DelegationsController < ApplicationController
  before_filter :authenticate_user!

  respond_to :html, :json

  def create
    delegation = current_user.delegations.new(params[:delegation])

    if delegation.save
      notice = {:notice => t('delegations.create.success')}
    else
      notice = {:error => t('delegations.create.failure')}
    end

    respond_with do |format|
      format.html{ redirect_to :back, notice }
      format.json{ render :nothing => true, :status => 204 }
    end
  end

  def destroy
    if current_user.delegations.find(params[:id]).delete
      notice = {:notice => t('delegations.destroy.success')}
    else
      notice = {:error => t('delegations.destroy.failure')}
    end

    respond_with do |format|
      format.html{ redirect_to :back, notice }
      format.json{ render :nothing => true, :status => 204 }
    end
  end

end
