# frozen_string_literal: true

class Api::UsersController < ApplicationController
  def create
    user = User.new(create_params)

    if user.save
      render json: success_json(user), status: :created
    else
      user.avatar.purge # TODO: Remove in Rails 6.0
      render json: error_json(user), status: :unprocessable_entity
    end
  end


  def show
    user = User.find_by(id: params[:id])

    if user.present?
      render json: success_json(user), status: :ok
    else
      head :not_found
    end
  end

  def avatar
    user = User.find_by(id: params[:id])

    if user&.avatar&.attached?
      redirect_to rails_blob_url(user.avatar)
    else
      head :not_found
    end
  end

  private

  def create_params
    params.require(:user).permit(:username, :avatar)
  end

  def success_json(user)
    {
      user: {
        id: user.id,
        username: user.username
      }
    }
  end

  def error_json(user)
    { errors: user.errors.full_messages }
  end
end
