defmodule ExGenius.Response do
  defstruct updated_by_human_at: 0, 
            title: nil, 
            primary_artist: nil, 
            pyongs_count: nil, 
            lyrics_updated_at: 0, 
            annotation_count: 0, 
            id: 0, 
            highlights: nil

  def get_song(%ExGenius.Response{ id: id}) do
    ExGenius.Song.find_by_id(id)
  end

  def from_json(json) do
    %ExGenius.Response{
      updated_by_human_at: json["updated_by_human_at"],
      title: json["title"],
      lyrics_updated_at: json["lyrics_updated_at"],
      annotation_count: json["annotation_count"],
      id: json["id"],
      pyongs_count: json["pyongs_count"]
    }
  end
end
