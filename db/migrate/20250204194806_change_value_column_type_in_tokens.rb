class ChangeValueColumnTypeInTokens < ActiveRecord::Migration[7.0]
  def up
    # Ensure all string values in the column are valid numbers
    # Optionally, add a transformation here before altering the column type if needed
    # Token.find_each do |token|
    #   token.update_columns(value: token.value.to_f.to_s) # Ensuring conversion to a proper numeric-like string
    # end
  
    # Change the column type with explicit casting
    change_column :tokens, :value, :decimal, using: 'value::numeric'
  end

  def down
    # If you need to rollback the migration
    change_column :tokens, :value, :string
  end
end
