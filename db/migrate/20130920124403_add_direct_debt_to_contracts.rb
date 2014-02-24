class AddDirectDebtToContracts < ActiveRecord::Migration
  def change
    add_column :contracts, :direct_debit, :boolean
  end
end
