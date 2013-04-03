class Projects::Epics::Stories::CommentsController < Projects::Epics::StoriesController
  before_filter :find_story

  def index
    @comments = @story.comments
  end

  def new
    @comment = Comment.new
  end

  def create
    @comment = @story.comments.create params[:comment]
    redirect_to [@project, @epic]
  end
end
