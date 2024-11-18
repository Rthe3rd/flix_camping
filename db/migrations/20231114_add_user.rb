Sequel.migration do
  up do
    create_table(:users) do
      primary_kegiy :id
      String :name, null: false
      DateTime :created_at, null: false
      DateTime :updated_at, null: false
    end
  end
  down do
    drop_table(:users)
  end
end