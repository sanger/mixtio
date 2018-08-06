class ProjectsController < ApplicationController

  before_action :projects, only: [:index]
  before_action :authenticate!, except: [:index]

  helper_method :projects

  def index
    @archive = false
  end

  def archive_index
    @archive = true
    render :index
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
    @project = current_resource
  end

  # PUT /projects/1/deactivate
  def deactivate
    @project = current_resource
    @project.deactivate!
    redirect_back(fallback_location: projects_path)
  end

  # PUT /projects/1/activate
  def activate
    @project = current_resource
    @project.activate!
    redirect_back(fallback_location: projects_archive_path)
  end

  # POST /projects
  def create
    @project = Project.new(project_params)
    if @project.save
      redirect_to projects_path, notice: "Project successfully created"
    else
      render :new
    end
  end

  # PATCH/PUT /projects/1
  def update
    @project = current_resource
    if @project.update_attributes(project_params)
      redirect_to (@project.active? ? projects_path : projects_archive_path), notice: "Project successfully updated"
    else
      render :edit
    end
  end

  private

    def projects
      @projects ||= (@archive ? Project.inactive : Project.active).page(params[:page])
    end

    def current_resource
      Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:name)
    end
end
