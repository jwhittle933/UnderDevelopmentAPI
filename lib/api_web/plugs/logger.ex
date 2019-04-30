defmodule ApiWeb.Plug.Logger do

  def init(options), do: options

  def call(conn, _params), do: conn

end