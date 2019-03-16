module SessionsHelper
    def log_in(user)
        session[:user_id] = user
    end
    
    def current_user
        if session[:id]
            @current_user ||= User.find_by(id:session[:id])
        end
    end
   
    def logged_in?
        !current_user.nil?
    end

end
