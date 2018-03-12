class PostsController < ApplicationController
	before_action :set_post, only: [:show, :edit, :update, :destroy]

	def index
		@posts=Post.all.order("created_at DESC")
	end
	def create
		@post = Post.new(post_params)
		@post.user_id = current_user.id
		print (@user)
		if @post.save
			redirect_to @post
		else 
			render 'new'
		end
	end
	def new
		@post=Post.new
	end
	def edit
	end
	def show
		@user = User.find(@post.user_id)
	end
	def update
			if @post.user_id == current_user.id
				if @post.update(params[:post].permit(:title, :body))
					redirect_to @post
				else
					render 'edit'
				end
		else 
			if user_signed_in?
				redirect_to @post,
     			notice: "Only Owner Who Can Edit The Post"
			else 
				redirect_to new_user_session_path
			end
		end
	end
	def destroy
		@post = Post.find(params[:id])
		if @post.user_id == current_user.id
			@post.destroy
			redirect_to posts_path
		else 
			if user_signed_in?
				redirect_to root_path,
     			notice: "Only Owner Who Can Delete The Post"
			else 
				redirect_to new_user_session_path
			end
		end
	end


	 private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :body)
    end
end
