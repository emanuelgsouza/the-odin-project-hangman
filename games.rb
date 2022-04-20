require 'json'

FILENAME = './games.json'

class Games
  def self.get_games()
    contents = File.read(FILENAME)

    JSON.parse(contents, { symbolize_names: true })
  end

  def self.store_game(game)
    games = self.get_games()
    games[game[:uuid].to_sym] = game
    contents = File.open(FILENAME, "w")
    contents.write(JSON.dump(games))
    contents.close()
  end

  def self.load_game(uuid)
    games = self.get_games()
    game_hash = games.fetch(uuid)
    game = Game.new(game_hash[:word], game_hash[:max_failure_attempts])
    game.from_json(game_hash)

    game
  end
end