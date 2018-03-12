class CommentsController < ApplicationController
	def create
		@post=Post.find(params[:post_id])
		if user_signed_in?
			@comment=@post.comments.create(params[:comment].permit(:name,:body).merge(user:current_user.id))
			redirect_to post_path(@post)
		else 
			@comment=@post.comments.create(params[:comment].permit(:name,:body).merge(user:0))
			redirect_to post_path(@post),
		notice: "Only Owner Who Can add The Post"
		end

	end
	def edit
		@post=Post.find(params[:post_id])
		@comment=@post.comments.find(params[:id])
	end
	
	def update
			if @comment.user == current_user.id
				if @comment.update(params[:comment].permit(:title, :body).merge(user_id: current_user.id))
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
		@post = Post.find(params[:post_id])
		@comment = @post.comments.find(params[:id])
		if @comment.user == current_user.id
			@comment.destroy
			redirect_to post_path(@post)
		else 
			if user_signed_in?
				redirect_to @post,
     			notice: "Only Owner Who Can Delete The Comment"
			else 
				redirect_to new_user_session_path
			end
		end

	end
end