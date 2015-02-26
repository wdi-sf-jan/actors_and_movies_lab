class CommentsController < ApplicationController
 before_filter :find_commentable

def create
  @commentable = find_commentable
  @comment = Comment.new(comment_params)
  if @comment.save
    @commentable.comments << @comment
  end
  redirect_to :back
end

private 
  
  def find_commentable   #finds out if actor or movie
    params.each do |name,value|
      if name =~ /(.+)_id$/   #a regular expression, which is looking for any number of leading 
      #  characters with _id at the end of a string
      # the =~ finds a match or returns nil
      # the $1 tells it to take the value that's in the first set of parens above
        return $1.classify.constantize.find(value)
        #turns it into Movie.find(value) or Actor.find(value)
      end
    end
  end
    
  def comment_params
    params.require(:comment).permit(:content)
  end
 

end