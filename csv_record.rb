$record_class = Class.new(Object) do
  attr_accessor :data

  def initialize(hash)
    @data = hash
  end

  def self.find(id)
    data = self.all.find{|h| h["id"] == id.to_s }
    self.new(data.dup)
  end

  def self.all
    self.class_variable_get("@@data")
  end

  def save
    id = self.id
    new_data = self.class.all.map do |line|
      if line["id"] == id
        self.data
      else
        line
      end
    end
    self.class.class_variable_set("@@data", new_data)
    write_to_csv
  end

  private
  def write_to_csv
    lines = []
    lines << self.class.all[0].keys
    self.class.all.each do |i|
      lines << i.values
    end
    File.open("test.csv", "w") do |file|
      lines.each do |line|
        file.write("#{line.join(',')}\n")
      end
    end
  end
end





class Record
  def initialize(class_name)
    File.open("#{class_name.downcase}.csv") do |file|
      Object.const_set("#{class_name.capitalize}", $record_class.dup)
      the_class = Object.const_get("#{class_name.capitalize}")
      data = []
      head_line = []

      file.each_with_index do |line, index|
        arr = line.strip.split(',')
        if index == 0
          head_line = arr
          head_line.each do |attr_name|
            the_class.send(:define_method, "#{attr_name}", lambda { @data["#{attr_name}"] })
            the_class.send(:define_method, "#{attr_name}=", lambda { |arg| @data["#{attr_name}"] = arg })
          end
        else
          data << head_line.zip(arr).to_h
        end
      end
      the_class.class_variable_set(:@@data, data)
    end
  end
end










