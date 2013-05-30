class Admin::UsersController < ApplicationController
  
  before_filter :activated_user!
  before_filter :admin_user!, :except => [:edit, :update]
  before_filter :admin_or_owner_only!, :only => [:edit, :update]
  before_filter :set_positions

  def admin_or_owner_only!
    @user = User.find(params[:id])
    redirect_to root_path, error: "You can't do that!" unless current_user.is_admin or current_user == @user
  end
  
  def index
    @users = User.find(:all, :order => "name ASC")
  end
  
  def new
    @user = User.new
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to admin_users_path, notice: 'User was successfully created.'
    else
      render action: "new"
    end
  end
  
  def update
    @user = User.find(params[:id])
    # if password is empty (user didn't want to change), don't update it
    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
    # can only change these fields if you are an admin
    unless current_user.is_admin
      params[:user].delete(:is_admin)
    end
    if @user.update_attributes(params[:user])
      redirect_to edit_admin_user_path, notice: 'User was successfully updated.' 
    else
      flash[:error] = "User couldn't be updated"
      render action: "edit"
    end
  end

  # toggle user activation
  def activate
    @user = User.find(params[:id])
    @user.is_activated = (not @user.is_activated)
    if @user.save
      flash[:notice] = "User #{@user.is_activated ? 'activated!' : 'deactivated!'}!"
    else
      flash[:error] = "Couldn't #{@user.is_activated ? 'activate' : 'deactivate'} user."
    end
    redirect_to admin_users_path
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_path
  end
end
