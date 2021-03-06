defmodule SimpleServer.Web do
  @moduledoc """
  This is the router, which is really the core of SimpleServer.
  """
  
  use Plug.Router
  require Logger

  plug Plug.Logger
  plug Plug.Static,
    at: "/", from: :simple_server,
    only: ~w(css images js favicon.ico robots.txt)
  plug :match
  plug :dispatch

  def init(options) do
    options
  end

  @doc """
    Start the server
  """
  def start_link do
    {:ok, _} = Plug.Adapters.Cowboy.http SimpleServer.Web, []
  end

  get "/" do
    page_contents = EEx.eval_file("templates/index.html.eex")
    conn |> Plug.Conn.put_resp_content_type("text/html") |> Plug.Conn.send_resp(200, page_contents) |> halt
  end

	@doc """
    Handle 404s
	"""
  match _ do
    send_resp(conn, 404, "not found")
  end
end