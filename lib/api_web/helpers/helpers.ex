defmodule ApiWeb.Helpers do

  import Ecto.Changeset, only: [traverse_errors: 2]
  import Poison

  def get_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end

  defp get_resp_body(resp) do
    {:ok, body} = resp.resp_body |> decode
    body
  end



end
