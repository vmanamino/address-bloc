require_relative "entry.rb"
require 'csv'

class AddressBook
  attr_accessor :entries

  def initialize
    @entries = []
  end

  def add_entry(name, phone, email)
    index = 0
    @entries.each do |entry|
      # keep lexicographical order
      if name < entry.name
        break
      end
      index += 1
    end
    @entries.insert(index, Entry.new(name, phone, email))
  end

  def view_entry_number(entry)
    index = get_index(entry)
    entry = @entries[index]
    return entry
  end

  def remove_entry(entry)
    index = get_index(entry)
    @entries.delete_at(index)
  end

  def get_index(input)
    input - 1
  end

  def import_from_csv(file_name)
    csv_text = File.read(file_name)
    csv = CSV.parse(csv_text, headers: true, skip_blanks: true)
    csv.each do |row|
      row_hash = row.to_hash
      add_entry(row_hash["name"], row_hash["phone_number"], row_hash["email"])
    end
  end
end
