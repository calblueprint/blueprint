class Admin::ProjectsController < ApplicationController

  before_filter :confirmed_user!
  before_filter :admin_user!

  def index
    @projects = Project.all
  end

  def new
    @project = Project.new
  end

  def edit
    @project = Project.find(params[:id])
  end

  def create
    @project = Project.new(params[:project])
    if @project.save
      redirect_to admin_projects_path, notice: 'New project was created!'
    else
      render action: "new"
    end
  end

  def update
    @project = Project.find(params[:id])
    if @project.update_attributes(params[:project])
      redirect_to admin_projects_path, notice: "Project was updated."
    else
      render action: "edit"
    end
  end

  def destroy
    @project = Project.find(params[:id])
    @project.image = nil
    @project.destroy

    redirect_to admin_projects_path
  end
end
