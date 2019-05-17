defmodule ApiWeb.FallbackController do

  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See Phoenix.Controller.action_fallback/1 for more details.
  """

  use ApiWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    errors = get_errors(changeset)
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{errors: errors})
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> json(%{error: "not found"})
  end
end
