class AddColumnsCadLocalTrabalho < ActiveRecord::Migration
  def change
    change_table :cad_local_trabalho do |t|
      t.string :tipo_local, :null => false
      t.string :nome
      t.string :cep
      t.string :endereco
      t.string :numero
      t.string :bairro
      t.string :cidade
      t.string :estado
      t.string :telefone
      t.string :email
      t.string :site
      t.string :latitude
      t.string :longitude
    end
  end
end
