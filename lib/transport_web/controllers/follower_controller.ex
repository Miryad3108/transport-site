defmodule TransportWeb.FollowerController do
  use TransportWeb, :controller
  alias Transport.Datagouvfr.Client.Datasets

  def create(%Plug.Conn{} = conn, %{"dataset_id" => dataset_id, "is_subscribed" => "false"}) do
    conn
    |> Datasets.post_followers(dataset_id)
    |> handle_followers(dataset_id)
  end

  def create(%Plug.Conn{} = conn, %{"dataset_id" => dataset_id, "is_subscribed" => "true"}) do
    conn
    |> Datasets.delete_followers(dataset_id)
    |> handle_followers(dataset_id)
  end

  defp handle_followers(conn, dataset_id) do
    conn
    |> case do
      {:error, error} ->
        conn
        |> put_flash(:error, error)
      {:ok, _} -> conn
    end
    |> redirect(to: dataset_path(conn, :details, dataset_id))
  end
end
