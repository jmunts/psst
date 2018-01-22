defmodule API.ReminderController do
  use API, :controller

  def index(conn, _params) do
    reminders = Data.Reminder |> Data.Repo.all
    render conn, "index.json", reminders: reminders
  end

  def show(conn, %{"id" => id} = _params) do
    case reminder = Data.Repo.get(Data.Reminder, id) do
      %Data.Reminder{} ->
        conn
        |> render("reminder.json", reminder: reminder)
      nil ->
        conn
        |> put_status(:not_found)
        |> render(API.ErrorView, "404.json")
    end
  end

  def create(conn, %{"reminder" => reminder_params} = _params) do
    changeset = Data.Reminder.changeset %Data.Reminder{}, reminder_params

    case Data.Repo.insert(changeset) do
      {:ok, reminder} ->
        conn
        |> put_status(:created)
        |> render("reminder.json", reminder: reminder)
      {:error, changeset} ->
        errors = for {key, {message, _}} <- changeset.errors do
                   "#{key} #{message}"
                 end
        conn
        |> put_status(:unprocessable_entity)
        |> render(API.ErrorView, "422.json", errors: errors)
    end
  end

  def update(conn, %{"id" => id, "reminder" => reminder_params} = _params) do
    with reminder = %Data.Reminder{} <- Data.Repo.get(Data.Reminder, id),
         changeset = Data.Reminder.changeset(reminder, reminder_params),
         {:ok, reminder} <- Data.Repo.update(changeset) do
      conn
      |> put_status(:ok)
      |> render("reminder.json", reminder: reminder)
    else
      nil ->
        conn
        |> put_status(:not_found)
        |> render(API.ErrorView, "404.json")
      {:error, changeset} ->
        errors = for {key, {message, _}} <- changeset.errors do
          "#{key} #{message}"
        end
        conn
        |> put_status(:unprocessable_entity)
        |> render(API.ErrorView, "422.json", errors: errors)
    end
  end

  def delete(conn, %{"id" => id} = _params) do
    reminder = Data.Repo.get(Data.Reminder, id)

    case reminder do
      nil ->
        conn
        |> put_status(:not_found)
        |> render(API.ErrorView, "404.json")
      _ ->
        Data.Repo.delete(reminder)

        conn
        |> put_status(:no_content)
        |> send_resp(:no_content, "")
    end
  end

end
