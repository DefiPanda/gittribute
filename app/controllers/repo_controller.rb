include ApplicationHelper

class RepoController < ApplicationController
	def index
		@repo = Repo.paginate(:page => params[:page], :per_page => 30, :order => "created_at DESC")
	end

	def show
		url = request.original_url
		confirmed = false
    @repoid = 0
    @username = url[/user\/.*\/.*repo\//][5..-7]
    @repo = url.split("/")[-1]
    @error = ""
    @comment = []
    if User.find_by_username(@username).nil?
      confirmed = getVerified(url, @username, @repo)
      if confirmed
      	user_info = getParsedJSON("https://api.github.com/users/#{@username}", 1)
          userid = user_info["id"]
          #probably not useful because it will be the same as @username, but let's store it anyway
          user_login = user_info["login"]
          #we need to use update method in case the unlikely event that a user has changed his/her Github username
          User.find_or_create_by_userid!(:username => user_login, :userid => userid)
          
        end
    end
    userid = User.find_by_username(@username).userid
    @repo_description = ""
    #if the repo did not exist yet
    if Repo.find_by_userid_and_reponame(userid, @repo).nil?
    	if confirmed == false
        confirmed = getVerified(url, @username, @repo)
    	end
      if confirmed
        repoInfo = getRepoInfo(@username, @repo)
        @repo_description = repoInfo[1]
        @repoid = repoInfo[0]
        Repo.find_or_create_by_userid_and_repoid!(:reponame => @repo, :userid => userid, :repoid => @repoid, :description=> @repo_description)
      end
    else
      repo = Repo.find_by_userid_and_reponame(userid, @repo)
      @repo_description = repo.description
      @repoid = repo.repoid
    end
    if confirmed == false and Repo.find_by_userid_and_reponame(userid, @repo).nil?
    	@error = "You sure your URL is correct and you include this url in your Github repo?"
    else
      @comment = Comment.find_all_by_repoid(@repoid, :order => "created_at DESC")
    end
	end
end
