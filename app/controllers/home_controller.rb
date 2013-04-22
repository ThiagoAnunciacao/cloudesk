class HomeController < ApplicationController
  def index
    @users = User.all
    Pessoa.create nome: "Thiago"
  end

end
