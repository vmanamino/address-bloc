require_relative '../models/address_book.rb'

RSpec.describe AddressBook do

  let(:book) { AddressBook.new }

  def check_entry(entry, expected_name, expected_number, expected_email)
    expect(entry.name).to eql expected_name
    expect(entry.phone_number).to eql expected_number
    expect(entry.email).to eql expected_email
  end

  context "attributes" do
    it "should respond to entries" do
        expect(book).to respond_to(:entries)
    end
    it "should initialize entries as an array" do
        expect(book.entries).to be_a(Array)
    end
    it "should initialize entries as empty" do
        expect(book.entries.size).to eq 0
    end
  end
  context ".add_entry" do
    it "adds only one entry to the address book" do
      book.add_entry('Ada Lovelace', '010.012.1815', 'augusta.king@lovelace.com')
      expect(book.entries.size).to eq 1
    end
    it "adds the correct information to entries" do
      book.add_entry('Ada Lovelace', '010.012.1815', 'augusta.king@lovelace.com')
      new_entry = book.entries[0]
      expect(new_entry.name).to eq 'Ada Lovelace'
      expect(new_entry.phone_number).to eq '010.012.1815'
      expect(new_entry.email).to eq 'augusta.king@lovelace.com'
    end
    it 'adds entries in lexigraphical order by name' do
      names = ['d', 'b', 'c', 'e', 'a']
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
      book.add_entry('Ada Lovelace', '010.012.1815', 'augusta.king@lovelace.com')
      book.add_entry('Ada Orardor', '111.222.3333', 'vlad.nabokov@mir.com')
      book.remove_entry(2)
      expect(book.entries.size).to eq 1
    end
    it "removes the correct entry by number of entry" do
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
      names.each do |name|
        book.add_entry(name, '010.012.1815', 'noname@noone.com')
      end
      numbers.each do |number| # number of entry starting at 1
        entry = book.view_entry_number(number)
        expect(entry.name).to eq(book.entries[book.get_index(number)].name)
      end
    end
  end
  context '.import_from_csv' do
    it 'imports the correct number of entries' do
      book.import_from_csv("entries.csv")
      book_size = book.entries.size
      expect(book_size).to eql 5
    end
    it 'imports 1st entry' do
      book.import_from_csv("entries.csv")
      entry_one = book.entries[0]
      check_entry(entry_one, "Bill", "555-555-4854", "bill@blocmail.com")
    end
    it 'imports 2nd entry' do
      book.import_from_csv("entries.csv")
      entry_two = book.entries[1]
      check_entry(entry_two, "Bob", "555-555-5415", "bob@blocmail.com")
    end
    it 'imports 3rd entry' do
      book.import_from_csv("entries.csv")
      entry_three = book.entries[2]
      check_entry(entry_three, "Joe", "555-555-3660", "joe@blocmail.com")
    end
    it 'imports the 4th entry' do
      book.import_from_csv("entries.csv")
      entry_four = book.entries[3]
      check_entry(entry_four, "Sally", "555-555-4646", "sally@blocmail.com")
    end
    it 'imports the 5th entry' do
      book.import_from_csv("entries.csv")
      entry_five = book.entries[4]
      check_entry(entry_five, "Sussie", "555-555-2036", "sussie@blocmail.com")
    end
    it 'imports from any csv file that is given by user' do
      book.import_from_csv("data/entries2.csv")
      size = book.entries.size
      expect(size).to eql 3
    end
    it 'imports the 1st entry from user given file' do
      book.import_from_csv("data/entries2.csv")
      entry_one = book.entries[0]
      check_entry(entry_one, "Bill", "555-555-4854", "bill@blocmail.com")
    end
    it 'imports the 2nd entry from user given file' do
      book.import_from_csv("data/entries2.csv")
      entry_two = book.entries[1]
      check_entry(entry_two, "Bob", "555-555-5415", "bob@blocmail.com")
    end
    it 'imports 3rd entry from user given file' do
      book.import_from_csv("data/entries2.csv")
      entry_three = book.entries[2]
      check_entry(entry_three, "Joe", "555-555-3660", "joe@blocmail.com")
    end
  end
  context "#binary_search" do
    it 'searches AddressBook for a non-existent entry' do
      book.import_from_csv("entries.csv")
      entry = book.binary_search("Dan")
      expect(entry).to be_nil
    end
    it 'searches AddressBook for Bob' do
      book.import_from_csv("entries.csv")
      entry = book.binary_search("Bob")
      expect(entry).to be_a Entry
      check_entry(entry, "Bob", "555-555-5415", "bob@blocmail.com")
    end
    it 'searches AddressBook for Joe' do
      book.import_from_csv("entries.csv")
      entry = book.binary_search("Joe")
      expect(entry).to be_a Entry
      check_entry(entry, "Joe", "555-555-3660", "joe@blocmail.com")
    end
    it "searches AddressBook for Sally" do
      book.import_from_csv("entries.csv")
      entry = book.binary_search("Sally")
      expect(entry).to be_a Entry
      check_entry(entry, "Sally", "555-555-4646", "sally@blocmail.com")
    end
    it "searches AddressBook for Sussie" do
      book.import_from_csv("entries.csv")
      entry = book.binary_search("Sussie")
      expect(entry).to be_a Entry
      check_entry(entry, "Sussie", "555-555-2036", "sussie@blocmail.com")
    end
    it 'searches AddressBook for non-entry Billy' do
      book.import_from_csv("entries.csv")
      entry = book.binary_search("Billy")
      expect(entry).to be_nil
    end
  end
  context ".iterative_search" do
    it 'searches AddressBook for a non-existent entry' do
      book.import_from_csv("entries.csv")
      entry = book.iterative_search("Dan")
      expect(entry).to be_nil
    end
    it 'searches AddressBook for Bob' do
      book.import_from_csv("entries.csv")
      entry = book.iterative_search("Bob")
      expect(entry).to be_a Entry
      check_entry(entry, "Bob", "555-555-5415", "bob@blocmail.com")
    end
    it 'searches AddressBook for Joe' do
      book.import_from_csv("entries.csv")
      entry = book.iterative_search("Joe")
      expect(entry).to be_a Entry
      check_entry(entry, "Joe", "555-555-3660", "joe@blocmail.com")
    end
    it "searches AddressBook for Sally" do
      book.import_from_csv("entries.csv")
      entry = book.iterative_search("Sally")
      expect(entry).to be_a Entry
      check_entry(entry, "Sally", "555-555-4646", "sally@blocmail.com")
    end
    it "searches AddressBook for Sussie" do
      book.import_from_csv("entries.csv")
      entry = book.iterative_search("Sussie")
      expect(entry).to be_a Entry
      check_entry(entry, "Sussie", "555-555-2036", "sussie@blocmail.com")
    end
    it 'searches AddressBook for non-entry Billy' do
      book.import_from_csv("entries.csv")
      entry = book.iterative_search("Billy")
      expect(entry).to be_nil
    end
  end
end