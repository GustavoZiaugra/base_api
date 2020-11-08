defmodule BaseApi.HTTPAPI do
  @moduledoc """
  HTTPAPI module for managing external HTTP requests.
  """

  require Logger

  defmodule Error do
    defexception url: nil, status_code: nil, reason: nil, id: nil

    @type t :: %__MODULE__{reason: any, url: String.t(), status_code: integer | nil}

    def message(%__MODULE__{reason: reason, url: url, status_code: status_code}),
      do: "[url: #{url}, status_code: #{status_code}] - #{inspect(reason)}"

    def new(reason, url, status_code \\ nil) do
      %__MODULE__{reason: reason, url: url, status_code: status_code}
    end
  end

  @doc """
  Sends a GET request logging the relevant parameters.
  """
  def get_request(url, headers, options \\ []) do
    httpoison_opts = handle_opts(options)

    Logger.info("""
    BaseApi.HTTPAPI is performing a GET request. Context:
    url = #{inspect(url)}
    headers = #{inspect(headers)}
    options = #{inspect(options)}
    httpoison_opts = #{inspect(httpoison_opts)}
    """)

    case HTTPoison.get(url, headers, httpoison_opts) do
      {:error, error} ->
        {:error, Error.new(error.reason, url)}

      result ->
        result
    end
  end

  @doc """
  Sends a POST request logging the relevant parameters.
  """
  def post_request(url, body, headers, options) do
    httpoison_opts = handle_opts(options)

    Logger.info("""
    BaseApi.HTTPAPI is performing a POST request. Context:
    url = #{inspect(url)}
    body = #{inspect(body)}
    headers = #{inspect(headers)}
    options = #{inspect(options)}
    httpoison_opts = #{inspect(httpoison_opts)}
    """)

    case HTTPoison.post(url, body, headers, httpoison_opts) do
      {:error, error} ->
        {:error, Error.new(error.reason, url)}

      result ->
        result
    end
  end

  @doc """
  Sends a PUT request logging the relevant parameters.
  """
  def put_request(url, body, headers, options) do
    httpoison_opts = handle_opts(options)

    Logger.info("""
    BaseApi.HTTPAPI is performing a PUT request. Context:
    url = #{inspect(url)}
    body = #{inspect(body)}
    headers = #{inspect(headers)}
    options = #{inspect(options)}
    httpoison_opts = #{inspect(httpoison_opts)}
    """)

    case HTTPoison.put(url, body, headers, httpoison_opts) do
      {:error, error} ->
        {:error, Error.new(error.reason, url)}

      result ->
        result
    end
  end

  @doc """
  Sends a DELETE request logging the relevant parameters.
  """
  def delete_request(url, headers, options) do
    httpoison_opts = handle_opts(options)

    Logger.info("""
    BaseApi.HTTPAPI is performing a DELETE request. Context:
    url = #{inspect(url)}
    headers = #{inspect(headers)}
    options = #{inspect(options)}
    httpoison_opts = #{inspect(httpoison_opts)}
    """)

    case HTTPoison.delete(url, headers, httpoison_opts) do
      {:error, error} ->
        {:error, Error.new(error.reason, url)}

      result ->
        result
    end
  end

  @doc """
  Parses the response and logs the relevant response parameters.
  """
  def handle_response(response, options \\ [], handler \\ &do_handle_response/1) do
    Logger.info("""
    BaseApi.HTTPAPI received a response. Context:
    response = #{inspect(response)}
    options = #{inspect(options)}
    """)

    handler.(response)
  end

  def do_handle_response(%{body: body, status_code: status_code} = _response)
      when status_code in 200..208 and body == "" do
    {:ok, body}
  end

  @doc """
  Parses the response.

  If it is not a successful response, with `status_code` in [200..208] it will return an {:error, error}.
  """
  def do_handle_response(%{body: body, status_code: status_code, request_url: url} = _response)
      when status_code in 200..208 do
    case Jason.decode(body) do
      {:ok, body} ->
        {:ok, body}

      {:error, _reason} ->
        handle_response_error(url, 200)
    end
  end

  def do_handle_response(%{body: body, status_code: status_code, request_url: url} = _response)
      when body == "" do
    {:error, Error.new(body, url, status_code)}
  end

  def do_handle_response(%{body: body, status_code: status_code, request_url: url} = _response) do
    case Jason.decode(body) do
      {:ok, data} ->
        {:error, Error.new(data, url, status_code)}

      {:error, _reason} ->
        handle_response_error(url, status_code)
    end
  end

  defp handle_response_error(url, status_code) do
    {:error, Error.new("failed to parse response", url, status_code)}
  end

  # Adding this option to avoid certificate errors (https://hexdocs.pm/httpoison/readme.html)
  defp handle_opts(opts), do: opts |> Keyword.merge(ssl: [{:versions, [:"tlsv1.2"]}])
end
