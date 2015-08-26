require_relative "../models/address_book"

class MenuController
  attr_accessor :address_book

  def initialize
    @address_book = AddressBook.new
  end

  def main_menu

    puts "Main Menu - #{@address_book.entries.count} entries"
    puts "1 - View all entries"
    puts "2 - View entry number n"
    puts "3 - Remove an entry n"
    puts "4 - Create an entry"
    puts "5 - Search for an entry"
    puts "6 - Import entries from a CSV"
    puts "7 - Exit"
    print "Enter your selection: "

    selection = gets.to_i
    puts "You picked #{selection}"

    case selection
      when 1
        system "clear"
        view_all_entries
        main_menu
      when 2
        system "clear"
        view_entry_number
        main_menu
      when 3
        system "clear"
        remove_entry
        main_menu
      when 4
        system "clear"
        create_entry
        main_menu
      when 5
        system "clear"
        search_entries
        main_menu
      when 6
        system "clear"
        read_csv
        main_menu
      when 7
        puts "Good Bye!"
        exit(0)
    else
      system "clear"
      puts "Sorry, that is not valid input"
      main_menu
    end

  end

  def view_all_entries
    # @number = 0
    @address_book.entries.each do |entry|
      @number = @address_book.entries.index(entry)
      @number = @number + 1
      system "clear"
      puts @number
      puts entry.to_s
      option_submenu(entry)
    end
    system "clear"
    puts "End of entries"

  end

  def view_entry_number(message="Give entry number: ")
    system "clear"
    print message
    entry = gets.chomp
    if entry == 'm'
      system "clear"
      main_menu
    elsif entry.to_i.to_s != entry
      system "clear"
      message = "You need to enter the proper integer to do that!\nEnter m to return to the main menu\nOr enter the proper entry number: "
      view_entry_number(message)
    else
      entry = entry.to_i
      eintrag = @address_book.view_entry_number(entry)
      puts eintrag.to_s
    end
  end

  def remove_entry
    system "clear"
    puts "Remove AddressBloc Entry"
    print "Provide Entry #: "
    entry_number = gets.to_i
    entry = @address_book.entries[entry_number - 1]
    @address_book.remove_entry(entry_number)
    system "clear"
    puts "Entry #{entry_number} (#{entry.name}, #{entry.phone_number}, #{entry.email}) removed."
  end

  def create_entry
    system "clear"
    puts "New AddressBloc Entry"
    print "Name: "
    name = gets.chomp
    print "Phone number: "
    phone = gets.chomp
    print "Email: "
    email = gets.chomp
    @address_book.add_entry(name, phone, email)
    system "clear"
    puts "New entry created"
  end

  def search_entries

  end

  def read_csv
    system "clear"
    puts "Read in entries from a CSV formatted file"
    print "Enter the file: "
    file_name = gets.chomp
    @address_book.import_from_csv(file_name)
    system "clear"
    puts "Entries added!"
  end

  def option_submenu(entry)

    puts "n - next entry"
    puts "d - delete entry"
    puts "e - edit entry"
    puts "m - return to main menu"

    selection = gets.chomp

    case selection
      when "n"
      when "d"
        system "clear"
        @address_book.remove_entry(@number)
      when "e"
      when "m"
        system "clear"
        main_menu
      else
        system "clear"
        puts "#{selection} is not a valid input"
        entries_submenu(entry)
    end
  end
end
