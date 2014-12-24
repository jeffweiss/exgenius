defmodule ExGenius.Song do
  @moduledoc """
  %ExGenius.Song{} holds the essential elements on a song, while the functions
  of the module allow for locating a song by its id and pulling out its lyrics.
  """

  defstruct id: 0, lyrics: nil, title: nil

  @doc """
  Find a song by the Genius id. Also takes a `text_format`. The API
  understands text_format values of "dom", "html", "markdown", "plain".

  Although the Genius API supports multiple `text_format`s separated by a
  comma, this library does not.

  ## Examples

    iex> 202 |> ExGenius.Song.find_by_id |> ExGenius.Song.lyrics |> Enum.take(3)
    ["[Produced By: Warren G]", "[Intro]",
       "Regulators. We regulate any stealing of his property, we’re damn good too. But you can’t be any geek off the street. You’ve gotta be handy with the steel if you know what I mean, earn your keep. Regulators, mount up!"]

    iex> 367350 |> ExGenius.Song.find_by_id |> ExGenius.Song.lyrics |> Enum.take(3)
    ["Lean and small", "Works for all", "Ruby is my all in all"]

    iex> 202 |> ExGenius.Song.find_by_id(text_format: "markdown") |> ExGenius.Song.lyrics |> Enum.take(3)
    ["[[Produced By: Warren G]](/2467766/Warren-g-regulate/Produced-by-warren-g)  ",
       "    ", "[Intro]  "]

  """
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
      title: song["title"],
      lyrics: lyrics(song["lyrics"], text_format)
    }
  end

  defp lyrics(lyrics, text_format) do
    lyrics
    |> Map.get(text_format)
    |> tokenize_lyrics_into_array(text_format)
  end
  defp tokenize_lyrics_into_array(lyrics, "plain") do
    lyrics
    |> String.split("\n", trim: true)
  end
  defp tokenize_lyrics_into_array(lyrics, "markdown") do
    lyrics
    |> String.split("\n", trim: true)
  end

  @doc """
  Retrieves the lyrics for a particular song.
  """
  def lyrics(id) when is_integer(id) do
    id
    |> find_by_id
    |> lyrics
  end
  def lyrics(%ExGenius.Song{lyrics: lyrics}) do
    lyrics
  end

end
