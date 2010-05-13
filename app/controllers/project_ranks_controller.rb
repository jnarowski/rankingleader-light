class ProjectRanksController < HomeController
  
  def load_project_ranks
    @last_rank = @current_project.last_rank
    @current_rank = @current_project.current_rank
  end
  
  def new
    @project_rank = ProjectRank.new
  end
  
  def create
    @project_rank = ProjectRank.new(params[:project_rank])
    @project_rank.project_id = @current_project.id
    @project_rank.save
    load_project_ranks if @project_rank.errors.empty?
  end

end