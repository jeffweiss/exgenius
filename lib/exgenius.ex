defmodule ExGenius do

  def search(string) do
    params = %{"q" => string} |> URI.encode_query
    "http://api.genius.com/search?" <> params
    |> HTTPoison.get!
    |> Map.get(:body)
    |> JSX.decode!
  end

  def song(id) when is_integer(id), do: id |> to_string |> song
  def song(id) do
    "http://api.genius.com/songs/" <> id
    |> HTTPoison.get!
    |> Map.get(:body)
    |> JSX.decode!
  end

  def strip_br_tags(lyrics) do
    lyrics
    |> Enum.reject(fn(x) -> is_map(x) && Map.get(x, "tag") == "br" end)
  end

  def pull_out_children(lyrics) do
    lyrics
    |> Enum.map(&_pull_out_children/1)
  end
  defp _pull_out_children(lyric) when is_binary(lyric), do: lyric
  defp _pull_out_children(lyric) when is_map(lyric) do
    lyric
    |> Map.get("children")
  end

  def deannotate(lyrics) when is_list(lyrics) do
    lyrics
    |> Enum.map(&deannotate/1)
    |> List.flatten
    |> Enum.reject(&Kernel.is_nil/1)
  end
  def deannotate(lyrics) when is_binary(lyrics) do
    lyrics
  end
  def deannotate(lyrics) when is_map(lyrics) do
    case Map.get(lyrics, "children") do
      nil -> nil
      list -> deannotate(list)
    end
  end

  def random_lyrics_from(song, num \\ 3) do
    :random.seed(:erlang.now)
    song_id  = search(song)
    |> Map.get("response")
    |> Map.get("hits")
    |> List.first
    |> Map.get("result")
    |> Map.get("id")
    
    song(song_id)
    |> Map.get("response")
    |> Map.get("song")
    |> Map.get("lyrics")
    |> Map.get("dom")
    |> deannotate
    |> Enum.shuffle
    |> Enum.take(num)

  end


end
