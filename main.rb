require './countries_utils'
require './game'
require './games'
require './utils'

class Program
  include Utils

  def initialize()
    puts "======== Initializing the game ========\n"
    countries_utils = CountriesUtils.new
    @selected_country = countries_utils.choose_country_between(5, 12)
  end

  def choose_game_key(keys)
    puts "These are the key games. Choose one from a UUID"
    keys.each do |key|
      puts "- #{key}"
    end

    response = gets.chomp
    response = response.to_sym

    if keys.include? response
      return response
    end

    puts "Please, choose a correct key"
  end

  def start()
    answer = get_user_answer("Do you wan to load a saved game?")

    if !answer
      game = Game.new(@selected_country)
      game.play()
      puts "Finish"
      return
    end

    games = Games.get_games()

    uuid = choose_game_key(games.keys())
    game = Games.load_game(uuid)
    game.play()
  end
end

program = Program.new

program.start()