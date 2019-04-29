defmodule ApiWeb.Plugs.Logger do
  import Plug.Conn

  def init(options), do: options

  def call(conn, _params), do: conn

end