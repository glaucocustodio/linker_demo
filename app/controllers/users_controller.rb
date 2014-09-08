class UsersController < ApplicationController
  before_filter :set_users_form, except: [:index, :destroy]

  def index
    @users = User.all
  end

  def new
  end

  def create
    @user_form.params = users_form_params

    if @user_form.save
      redirect_to users_path, notice: 'User created successfully'
    else
      render :new
    end
  end

  def update
    @user_form.params = users_form_params

    if @user_form.save
      redirect_to users_path, notice: 'User updated successfully'
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path, notice: 'User destroyed successfully'
  end

  private
    def set_users_form
      if params[:id].present?
        @user_form = UserForm.new(User.find params[:id])
      else
        @user_form = UserForm.new(User.new)
      end
    end

    def users_form_params
      params.require(:user).permit(:name, :avatar,
                                   company_attributes: [:id, :name, :website],
                                   my_family_attributes: [:id, :last_name],
                                   address_attributes: [:id, :street, :district],
                                   tasks_attributes: [[:id, :name]],
                                   dependent_users_attributes: [[:id, :name, :date_birth]])
    end
end
