defmodule ExGenius.Song do
  defstruct id: 0, lyrics: nil#, title: nil

  def find_by_id(id, opts \\ [text_format: "plain"])
  def find_by_id(id, opts) when is_integer(id), do: id |> to_string |> find_by_id(opts)
  def find_by_id(id, opts) when is_binary(id) do
    text_format = Keyword.get(opts, :text_format, "plain")
    params = %{"text_format" => text_format} |> URI.encode_query
    "http://api.genius.com/songs/" <> id <> "?" <> params
    |> HTTPoison.get!(%{"User-Agent" => "ExGenius/0.0.3 (https://github.com/jeffweiss/exgenius)"})
    |> Map.get(:body)
    |> JSX.decode!
    |> from_json(text_format)
  end

  defp from_json(json, text_format) do
    song = json["response"]["song"]
    %ExGenius.Song{
      id: song["id"],
      #title: song["title"],
      lyrics: lyrics(song["lyrics"], text_format)
    }
  end

  def lyrics(lyrics, text_format) do
    lyrics
    |> Map.get(text_format)
    |> tokenize_lyrics_into_array(text_format)
  end
  def tokenize_lyrics_into_array(lyrics, "plain") do
    lyrics
    |> String.split("\n", trim: true)
  end

  def lyrics(id) when is_integer(id) do
    id
    |> find_by_id
    |> lyrics
  end
  def lyrics(%ExGenius.Song{lyrics: lyrics}) do
    lyrics
  end
  

end
