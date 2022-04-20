require 'json'
require 'securerandom'

require './games'
require './utils'

class Game
  include Utils

  def initialize(word, max_failure_attempts = 10)
    @uuid = SecureRandom.uuid.to_sym
    @word = word
    @max_failure_attempts = max_failure_attempts
    @attempts = []
    @right_attempts = []
    @wrong_attempts = []
    @failure_attempts = 0
  end

  def play
    breaked = false

    while @failure_attempts <= @max_failure_attempts && !got_the_word?
      wants_save = get_user_answer("Do you want to take some rest? If so, you can save this game")

      if wants_save
        Games.store_game(to_object)
        breaked = true
        break
      end

      puts "======== Play attempt ========"
      puts "The current play is #{attempts_word()}\n"
      puts "The wrong letters were #{@wrong_attempts.join(", ")}"

      letter = get_user_letter()

      attempt = {
        :letter => letter,
        :is_correct => nil
      }

      if @right_attempts.include?(letter) || @wrong_attempts.include?(letter)
        puts "You already try this letter\n"
        @attempts.push(attempt)
        next
      end

      attempt[:is_correct] = @word.include? letter

      if attempt[:is_correct]
        puts "You got the right letter, continue this amazing work :D"
        @right_attempts.push(letter)
      else
        @wrong_attempts.push(letter)
        puts "You are wrong dude :)"
        puts "You just have more #{@max_failure_attempts - @failure_attempts} attempts remaining"
        @failure_attempts += 1
      end

      @attempts.push(attempt)

      puts ""
    end

    if breaked
      puts "Ok... See you soon :)"
      return
    end

    if got_the_word?
      puts "Congrats! You finished the game and found out the word #{@word}"
    else
      puts "You were not be able to find out the word #{@word}, try again :("
    end
  end

  def attempts_word
    message = ""

    @word.each_char do |letter|
      if letter == " "
        message += " "
      else
        message += @right_attempts.include?(letter) ? "#{letter} " : "_ "
      end
    end

    message
  end

  def got_the_word?
    !attempts_word().include? "_"
  end

  def get_user_letter
    puts "Enter a letter"
    letter = gets.chomp
    letter = letter.downcase

    letter
  end

  def to_object
    return {
      :uuid => @uuid,
      :word => @word,
      :attempts => @attempts,
      :right_attempts => @right_attempts,
      :wrong_attempts => @wrong_attempts,
      :max_failure_attempts => @max_failure_attempts,
      :failure_attempts => @failure_attempts
    }
  end

  def from_json(data)
    @uuid = data[:uuid]
    @attempts = data[:attempts]
    @right_attempts = data[:right_attempts]
    @wrong_attempts = data[:wrong_attempts]
    @failure_attempts = data[:failure_attempts]
  end
end