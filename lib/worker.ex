defmodule Worker do
  @url "https://medium.com/topic/software-engineering"

  def read_url(url) do
    case HTTPoison.get url do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
       {:ok, body}
      {:ok, %HTTPoison.Response{body: body}} ->
       {:ok, body}
      {:error, _} ->
        {:error, []}
    end
  end

  def top_list do
    case read_url(@url) do
      {:ok, body} ->
        {:ok, document} = Floki.parse_document(body)
        parse_top_list(document)
      {:error, _} -> IO.puts "Errors"
    end
  end

  defp parse_a_post({document, id}) do
    [url]   = Floki.attribute(document, "href")
    url     = "https://medium.com" <> url
    title   = Floki.text(document)
    post_id = "post_#{id}"

    [{ String.to_atom(post_id), %{url: url, title: title} }]
  end

  defp parse_top_list(document) do
    Floki.find(document, "#root > div > div.n.p > div > div > div.de.df.dg.dh.di.dj.dk.dl.dm.dn.do.dp.dq.dr.ds.dt.du.dv.dw.dx.dy > div:nth-child(3) > div.gx.gy.r > section > div > section > div.hg.hh.fc.n.hi.hj.hk.hl.hm.al > div.hn.r.hm.al.ea > div.ft.fu > h3 > a")
    |> Enum.with_index()
    |> Enum.map(&parse_a_post(&1))
    |> List.flatten()
    |> Enum.into(%{})
  end

  def post(url) do
    case read_url(url) do
      {:ok, body} ->
        {:ok, document} = Floki.parse_document(body)
        parse_post(document)
      {:error, _} -> IO.puts "Errors"
    end
  end

  defp parse_post(document) do
    Floki.find(document, "#root > div > article > div > section > div.n.p > div")
    |> Floki.text()
  end
end
