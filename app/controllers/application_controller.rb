class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :confirm_logged_in

  def confirm_logged_in
    unless session[:user_id]
      redirect_to login_path, alert: "Please log in"
    end
  end

  private
    def find_entity
      params.each do |name, value|
        if name == 'controller'
          @entity = value.classify.constantize.find(params[:id]) || nil
        end
      end
    end

    def movie_params
      params.require(:movie).permit(:id, :title, :year)
    end

    def actor_params
      params.require(:actor).permit(:id, :name)
    end

end
