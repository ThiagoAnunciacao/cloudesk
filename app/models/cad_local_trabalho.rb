class CadLocalTrabalho
	include Mongoid::Document

	store_in collection: "cad_local_trabalho"

	field :tipo_local
	field :nome
	field :cep
	field :endereco
	field :numero
	field :bairro
	field :cidade
	field :estado
	field :telefone
	field :email
	field :site
	field :celular
	field :latitude
	field :longitude
end