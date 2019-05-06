defmodule ApiWeb.Helpers.GetRespBody do
  
  import Poison, only: [decode: 1]
  
  defp get_resp_body(conn) do
    {:ok, conn} = Map.fetch(conn, :resp_body)
    conn |> Poison.decode
  end

end