defmodule ApiWeb.Plug.Logger do
  import Plug.Conn
  import Plug.Logger

  def init(options), do: options

  def call(conn, _params), do: conn

end