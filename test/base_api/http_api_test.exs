defmodule BaseApi.HTTPAPITest do
  use BaseApi.DataCase
  import ExUnit.CaptureLog
  alias BaseApi.HTTPAPI

  def bypass(_context) do
    bypass = Bypass.open()

    {:ok, bypass: bypass}
  end

  describe "HTTPAPI.get_request/3" do
    setup [:bypass]

    test "creates a GET request", %{bypass: bypass} do
      Bypass.expect_once(bypass, fn conn ->
        assert "/" == conn.request_path
        assert "GET" == conn.method
        {:ok, _body, conn} = Plug.Conn.read_body(conn)

        conn
        |> Plug.Conn.put_resp_header("Content-Type", "text/html")
        |> Plug.Conn.send_resp(200, "ok")
      end)

      capture_log(fn ->
        {resp, _data} =
          HTTPAPI.get_request("http://localhost:#{bypass.port}", [
            {"Content-Type", "application/json"}
          ])

        assert resp == :ok
      end)
    end

    test "does not create a request with bad args", %{bypass: bypass} do
      Bypass.expect_once(bypass, fn conn ->
        assert "/" == conn.request_path
        assert "GET" == conn.method
        {:ok, _body, conn} = Plug.Conn.read_body(conn)

        conn
        |> Plug.Conn.put_resp_header("Content-Type", "text/html")
        |> Plug.Conn.send_resp(500, "error")
      end)

      capture_log(fn ->
        {_resp, data} =
          HTTPAPI.get_request("http://localhost:#{bypass.port}", [
            {"Content-Type", "application/json"}
          ])

        assert data.body == "error"
      end)
    end
  end

  describe "HTTPAPI.post_request/4" do
    setup [:bypass]

    test "creates a POST request", %{bypass: bypass} do
      Bypass.expect_once(bypass, fn conn ->
        assert "/" == conn.request_path
        assert "POST" == conn.method
        {:ok, _body, conn} = Plug.Conn.read_body(conn)

        conn
        |> Plug.Conn.put_resp_header("Content-Type", "text/html")
        |> Plug.Conn.send_resp(200, "ok")
      end)

      capture_log(fn ->
        {resp, _data} =
          HTTPAPI.post_request(
            "http://localhost:#{bypass.port}",
            %{} |> Jason.encode!(),
            [
              {"Content-Type", "application/json"}
            ],
            []
          )

        assert resp == :ok
      end)
    end

    test "does not create a request with bad args", %{bypass: bypass} do
      Bypass.expect_once(bypass, fn conn ->
        assert "/" == conn.request_path
        assert "POST" == conn.method
        {:ok, _body, conn} = Plug.Conn.read_body(conn)

        conn
        |> Plug.Conn.put_resp_header("Content-Type", "text/html")
        |> Plug.Conn.send_resp(500, "error")
      end)

      capture_log(fn ->
        {_resp, data} =
          HTTPAPI.post_request(
            "http://localhost:#{bypass.port}",
            %{} |> Jason.encode!(),
            [
              {"Content-Type", "application/json"}
            ],
            []
          )

        assert data.body == "error"
      end)
    end
  end

  describe "HTTPAPI.put_request/4" do
    setup [:bypass]

    test "creates a PUT request", %{bypass: bypass} do
      Bypass.expect_once(bypass, fn conn ->
        assert "/" == conn.request_path
        assert "PUT" == conn.method
        {:ok, _body, conn} = Plug.Conn.read_body(conn)

        conn
        |> Plug.Conn.put_resp_header("Content-Type", "text/html")
        |> Plug.Conn.send_resp(200, "ok")
      end)

      capture_log(fn ->
        {resp, _data} =
          HTTPAPI.put_request(
            "http://localhost:#{bypass.port}",
            %{} |> Jason.encode!(),
            [
              {"Content-Type", "application/json"}
            ],
            []
          )

        assert resp == :ok
      end)
    end

    test "does not create a request with bad args", %{bypass: bypass} do
      Bypass.expect_once(bypass, fn conn ->
        assert "/" == conn.request_path
        assert "PUT" == conn.method
        {:ok, _body, conn} = Plug.Conn.read_body(conn)

        conn
        |> Plug.Conn.put_resp_header("Content-Type", "text/html")
        |> Plug.Conn.send_resp(500, "error")
      end)

      capture_log(fn ->
        {_resp, data} =
          HTTPAPI.put_request(
            "http://localhost:#{bypass.port}",
            %{} |> Jason.encode!(),
            [
              {"Content-Type", "application/json"}
            ],
            []
          )

        assert data.body == "error"
      end)
    end
  end

  describe "HTTPAPI.delete_request/3" do
    setup [:bypass]

    test "creates a DELETE request", %{bypass: bypass} do
      Bypass.expect_once(bypass, fn conn ->
        assert "/" == conn.request_path
        assert "DELETE" == conn.method
        {:ok, _body, conn} = Plug.Conn.read_body(conn)

        conn
        |> Plug.Conn.put_resp_header("Content-Type", "text/html")
        |> Plug.Conn.send_resp(200, "ok")
      end)

      capture_log(fn ->
        {resp, _data} =
          HTTPAPI.delete_request(
            "http://localhost:#{bypass.port}",
            [
              {"Content-Type", "application/json"}
            ],
            []
          )

        assert resp == :ok
      end)
    end

    test "does not create a request with bad args", %{bypass: bypass} do
      Bypass.expect_once(bypass, fn conn ->
        assert "/" == conn.request_path
        assert "DELETE" == conn.method
        {:ok, _body, conn} = Plug.Conn.read_body(conn)

        conn
        |> Plug.Conn.put_resp_header("Content-Type", "text/html")
        |> Plug.Conn.send_resp(500, "error")
      end)

      capture_log(fn ->
        {_resp, data} =
          HTTPAPI.delete_request(
            "http://localhost:#{bypass.port}",
            [
              {"Content-Type", "application/json"}
            ],
            []
          )

        assert data.body == "error"
      end)
    end
  end
end
