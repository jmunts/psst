defmodule Web.ReminderController do
  use Web, :controller
  require IEx

  def index(conn, _params) do
    reminders = Data.Reminder |> Data.Repo.all
    render conn, "index.html", reminders: reminders
  end

  def new(conn, _params) do
    changeset = Data.Reminder.changeset(%Data.Reminder{})
    render conn, "new.html", changeset: changeset
  end

  def edit(conn, %{"id" => id} = _params) do
    reminder = Data.Repo.get(Data.Reminder, id)
    changeset = Data.Reminder.changeset(reminder)
    render conn, "edit.html", changeset: changeset
  end

  def create(conn, %{"reminder" => reminder_params} = _params) do
    changeset = Data.Reminder.changeset(%Data.Reminder{}, reminder_params)

    case Data.Repo.insert(changeset) do
      {:ok, _reminder} ->
        conn
        |> put_flash(:info, "Created successfully!")
        |> redirect(to: reminder_path(conn, :index))
      {:error, changeset} ->
        conn
        |> render("new.html", changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "reminder" => reminder_params} = _params) do
    reminder = Data.Repo.get(Data.Reminder, id)
    changeset = Data.Reminder.changeset(reminder, reminder_params)

    case Data.Repo.update(changeset) do
      {:ok, _reminder} ->
        conn
        |> put_flash(:info, "Saved!")
        |> redirect(to: reminder_path(conn, :index))
      {:error, changeset} ->
        conn
        |> render("edit.html", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id} = _params) do
    reminder = Data.Repo.get(Data.Reminder, id)

    Data.Repo.delete(reminder)

    conn
    |> put_flash(:error, "Reminder deleted")
    |> redirect(to: reminder_path(conn, :index))
  end

end
