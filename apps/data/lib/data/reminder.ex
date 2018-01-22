defmodule Data.Reminder do
  use Ecto.Schema

  schema "reminders" do
    field :description, :string
    field :status, :string, default: "active"
  end

  def changeset(reminder, params \\ %{}) do
    reminder
    |> Ecto.Changeset.cast(params, [:description, :status])
    |> Ecto.Changeset.validate_required([:description, :status])
  end

end
