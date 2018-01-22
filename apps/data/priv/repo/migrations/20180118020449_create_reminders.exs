defmodule Data.Repo.Migrations.CreateReminders do
  use Ecto.Migration

  def change do
    create table(:reminders) do
      add :description, :string
      add :status, :string
    end
  end
end
