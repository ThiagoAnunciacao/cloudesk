class CreateCadLocalTrabalho < ActiveRecord::Migration
  def change
    create_table :cad_local_trabalho do |t|

      t.timestamps
    end
  end
end
