require_relative '../models/address_book.rb'

RSpec.describe AddressBook do

  context "attributes" do
    it "should respond to entries" do
        book = AddressBook.new
        expect(book).to respond_to(:entries)
    end
    it "should initialize entries as an array" do
        book = AddressBook.new
        expect(book.entries).to be_a(Array)
    end
    it "should initialize entries as empty" do
        book = AddressBook.new
        expect(book.entries.size).to eq 0
    end
  end
  context ".add_entry" do
    it "adds only one entry to the address book" do
      book = AddressBook.new
      book.add_entry('Ada Lovelace', '010.012.1815', 'augusta.king@lovelace.com')
      expect(book.entries.size).to eq 1
    end
    it "adds the correct information to entries" do
      book = AddressBook.new
      book.add_entry('Ada Lovelace', '010.012.1815', 'augusta.king@lovelace.com')
      new_entry = book.entries[0]
      expect(new_entry.name).to eq 'Ada Lovelace'
      expect(new_entry.phone_number).to eq '010.012.1815'
      expect(new_entry.email).to eq 'augusta.king@lovelace.com'
    end
    it 'adds entries in lexigraphical order by name' do
      names = ['d', 'b', 'c', 'e', 'a']
      book = AddressBook.new
      names.each do |name|
        book.add_entry(name, '010.012.1815', 'noname@noone.com')
      end
      name = ''
      book.entries.each do |entry|
        expect(entry.name).to be > name
        name = entry.name
      end
    end
  end
  context ".remove_entry" do
    it "removes only one entry from the address book" do
      book = AddressBook.new
      book.add_entry('Ada Lovelace', '010.012.1815', 'augusta.king@lovelace.com')
      book.add_entry('Ada Orardor', '111.222.3333', 'vlad.nabokov@mir.com')
      book.remove_entry(2)
      expect(book.entries.size).to eq 1
    end
    it "removes the correct entry" do
      book = AddressBook.new
      # add_entry keeps alphabetical order, here entries added explicitly in ABC order
      book.add_entry('Ada Lovelace', '010.012.1815', 'augusta.king@lovelace.com')
      book.add_entry('Ada Orardor', '111.222.3333', 'vlad.nabokov@mir.com')
      book.add_entry('Ida Pardon', '333.444.5555', 'mountIda@parnassus.com')
      book.add_entry('Mike', '444.555.6666', 'mymail@dream.com')
      book.remove_entry(3)
      book.entries.each do |entry|
        expect(entry.name).not_to eq 'Ida Pardon'
        expect(entry.phone_number).not_to eq '333.444.5555'
        expect(entry.email).not_to eq 'mountIda@parnassus.com'
      end
    end
  end
  context '.index' do
    it 'calculates index of entry from input converted to integer' do
      book = AddressBook.new
      # add_entry keeps ABC order, here entries added explicitly ABC
      book.add_entry('Ada Lovelace', '010.012.1815', 'augusta.king@lovelace.com')
      book.add_entry('Ada Orardor', '111.222.3333', 'vlad.nabokov@mir.com')
      input = '1'
      entry = input.to_i
      expect(book.entries[book.get_index(entry)].name).to eq('Ada Lovelace')
    end
  end
  context '.view_entry_number' do
    it 'retrieves entries by integer starting at 1' do
      numbers = [1, 2, 3, 4, 5]
      names = ['d', 'b', 'c', 'e', 'a']
      book = AddressBook.new
      names.each do |name|
        book.add_entry(name, '010.012.1815', 'noname@noone.com')
      end
      numbers.each do |number| # number of entry starting at 1
        entry = book.view_entry_number(number)
        expect(entry.name).to eq(book.entries[book.get_index(number)].name)
      end
    end
  end
end