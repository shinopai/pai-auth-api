class Api::V1::UsersController < ApplicationController
  def index
    user = User.find_by(uid: params[:uid])
    logger.debug('ここから')
    logger.debug(user)
    logger.debug('ここまで')

    render json: user
  end

  def create
    user = User.new(user_params)

    if user.save
      render json: user, status: :created
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end


  private
  def user_params
    params.require(:user).permit(:name, :email, :uid)
  end
end
