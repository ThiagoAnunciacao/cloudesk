class CadLocalTrabalhoController < ApplicationController
	def index
		@cad_local_trabalho = CadLocalTrabalho.all
	end

	def new
  		@cad_local_trabalho = CadLocalTrabalho.new
  	end

    def create
  		@cad_local_trabalho = CadLocalTrabalho.new(params[:cad_local_trabalho])

  		if @cad_local_trabalho.save
    		redirect_to cad_local_trabalho_path, :notice => I18n.t('create.success')
      	else
        	render :action => :new
		end
    end

    def show
    	@cad_local_trabalhos = CadLocalTrabalho.all
    end

    def update

    end
end
