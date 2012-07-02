class Users::TransactionsController < UsersController
  before_filter :force_user

  def new
    @accounts = @current_user.accounts
  end

  def create
    from_account = @current_user.accounts.find(params[:from_account])
    from_account.transfer(amount: params[:amount].to_f, account: params[:to_account])
    redirect_to [@current_user, :accounts]
  end
end
