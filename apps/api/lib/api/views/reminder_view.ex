defmodule API.ReminderView do
  use API, :view

  def render("index.json", %{reminders: reminders}) do
    %{data: render_many(reminders, __MODULE__, "reminder.json")}
  end

  def render("reminder.json", %{reminder: reminder}) do
    %{
      id:          reminder.id,
      description: reminder.description,
      status:      reminder.status,
    }
  end


end
