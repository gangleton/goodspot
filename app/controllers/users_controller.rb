class UsersController < ApplicationController

  def verify
    @user = current_user
    if @user.verify!(params[:user][:verification_code])
      @user.phone_numbers.create( :number => params[:user][:phone_number] )
      redirect_to root_path, notice: 'Thanks for the information'
    else
      redirect_to root_path, alert: "Sorry, that code didn't work. Check spelling and capitalization and try again."
    end
  end
end
