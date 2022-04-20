module Utils
  def get_user_answer(message)
    puts message

    puts "yes (y)? or no (n)?"

    response = gets.chomp
    response = response.downcase
    
    if ['yes', 'y', 'no', 'n'].include? response
      return response == 'yes' || response == 'y'
    end

    get_user_answer()
  end
end