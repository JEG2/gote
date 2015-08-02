require_relative "../lib/gote/note_reference"

describe Gote::NoteReference do
  let(:configuration) {
    double(
      note_directory:    "notes",
      default_category:  "uncategorized",
      default_extension: ".md"
    )
  }

  it "recognizes categories" do
    reference = Gote::NoteReference.new(
      user_entry:    "category/test.rb",
      configuration: configuration
    )
    expect(reference.category).to eq("category")
  end

  it "defaults the category when not provided" do
    reference = Gote::NoteReference
      .new(user_entry: "test", configuration: configuration)
    expect(reference.category).to eq(configuration.default_category)
  end

  it "recognizes notes" do
    reference = Gote::NoteReference.new(
      user_entry:    "category/test.rb",
      configuration: configuration
    )
    expect(reference.note).to eq("test.rb")
  end

  it "defaults a note's extension" do
    reference = Gote::NoteReference
      .new(user_entry: "test", configuration: configuration)
    expect(reference.note).to eq("test#{configuration.default_extension}")
  end

  it "builds paths to include category directories" do
    reference = Gote::NoteReference.new(
      user_entry:    "category/test.rb",
      configuration: configuration
    )
    expect(reference.path).to eq(
      "#{configuration.note_directory}/categories/" +
      "#{reference.category}/#{reference.note}"
    )
  end

  it "builds paths to the special uncategorized directory" do
    reference = Gote::NoteReference.new(
      user_entry:    "test.rb",
      configuration: configuration
    )
    expect(reference.path).to eq(
      "#{configuration.note_directory}/#{reference.category}/#{reference.note}"
    )
  end

  it "knows the directory of a path" do
    reference = Gote::NoteReference.new(
      user_entry:    "category/test.rb",
      configuration: configuration
    )
    expect(reference.directory).to eq(File.dirname(reference.path))
  end
end
