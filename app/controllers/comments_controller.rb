class CommentsController < ApplicationController

  # # GET /comments/1
  # # GET /comments/1.json
  def show
    @comment = Comment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.json
  def new
    if session[:user_id].nil? == false
      @comment = Comment.new(:repoid => params[:repoid])

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @comment }
      end
    else
      @error = "Please log in"
    end
  end

  # POST /comments
  # POST /comments.json
  def create
    if session[:user_id].nil? == false
      @comment = Comment.new(params[:comment])

      respond_to do |format|
        if @comment.save
          format.html { redirect_to @comment, notice: 'Comment was successfully created.' }
          format.json { render json: @comment, status: :created, location: @comment }
        else
          format.html { render action: "new" }
          format.json { render json: @comment.errors, status: :unprocessable_entity }
        end
      end
    else
      @error = "Please log in"
    end
  end

end
