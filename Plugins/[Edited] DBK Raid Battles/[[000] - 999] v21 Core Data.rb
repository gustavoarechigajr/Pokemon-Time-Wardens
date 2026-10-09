class SpriteWindow_Base < SpriteWindow
  TEXT_PADDING = 4   # In pixels
end

class Pokemon
  class Move
    def physical_move?; return GameData::Move.get(@id).physical?;     end
    def special_move?;  return GameData::Move.get(@id).special?;      end
    def status_move?;   return GameData::Move.get(@id).status?;       end
  end
end

class Battle::Battler
  def hasZCrystal?; return false; end
end

module GameData
  module ClassMethods
    def schema
      return self::SCHEMA
    end
  end

  module ClassMethodsSymbols
    def schema
      return self::SCHEMA
    end
  end

  module ClassMethodsIDNumbers
    def schema
      return self::SCHEMA
    end
  end

  module InstanceMethods
    # @param other [Symbol, self.class, String, Integer]
    # @return [Boolean] whether other represents the same thing as this thing
    def ==(other)
      return false if other.nil?
      case other
      when Symbol
        return @id == other
      when self.class
        return @id == other.id
      when String
        return @id == other.to_sym
      when Integer
        return @id_number == other
      end
      return false
    end

    def get_property_for_PBS(key)
      ret = nil
      if self.class::SCHEMA.include?(key) && self.respond_to?(self.class::SCHEMA[key][0])
        ret = self.send(self.class::SCHEMA[key][0])
        ret = nil if ret == false || (ret.is_a?(Array) && ret.length == 0)
      end
      return ret
    end
  end


  #=============================================================================
  # A bulk loader method for all data stored in .dat files in the Data folder.
  #=============================================================================
  def self.load_all
    self.constants.each do |c|
      next if !self.const_get(c).is_a?(Class)
      self.const_get(c).load if self.const_get(c).const_defined?(:DATA_FILENAME)
    end
  end

  def self.get_all_data_filenames
    ret = []
    self.constants.each do |c|
      next if !self.const_get(c).is_a?(Class)
      next if !self.const_get(c).const_defined?(:DATA_FILENAME)
      if self.const_get(c).const_defined?(:OPTIONAL) && self.const_get(c)::OPTIONAL
        ret.push([self.const_get(c)::DATA_FILENAME, false])
      else
        ret.push([self.const_get(c)::DATA_FILENAME, true])
      end
    end
    return ret
  end

  def self.get_all_pbs_base_filenames
    ret = {}
    self.constants.each do |c|
      next if !self.const_get(c).is_a?(Class)
      ret[c] = self.const_get(c)::PBS_BASE_FILENAME if self.const_get(c).const_defined?(:PBS_BASE_FILENAME)
      next if !ret[c].is_a?(Array)
      ret[c].length.times do |i|
        next if i == 0
        ret[(c.to_s + i.to_s).to_sym] = ret[c][i]   # :Species1 => "pokemon_forms"
      end
      ret[c] = ret[c][0]   # :Species => "pokemon"
    end
    return ret
  end
end

module RaidFileLineData
  @file     = ""
  @linedata = ""
  @lineno   = 0
  @section  = nil
  @key      = nil
  @value    = nil

  def self.file; return @file; end
  def self.file=(value); @file = value; end

  def self.clear
    @file     = ""
    @linedata = ""
    @lineno   = ""
    @section  = nil
    @key      = nil
    @value    = nil
  end

  def self.setSection(section, key, value)
    @section = section
    @key     = key
    if value && value.length > 200
      @value = value[0, 200].to_s + "..."
    else
      @value = (value) ? value.clone : ""
    end
  end

  def self.setLine(line, lineno)
    @section  = nil
    @linedata = (line && line.length > 200) ? sprintf("%s...", line[0, 200]) : line.clone
    @lineno   = lineno
  end

  def self.linereport
    if @section
      if @key.nil?
        return _INTL("File {1}, section {2}\n{3}", @file, @section, @value) + "\n\n"
      else
        return _INTL("File {1}, section {2}, key {3}\n{4}", @file, @section, @key, @value) + "\n\n"
      end
    else
      return _INTL("File {1}, line {2}\n{3}", @file, @lineno, @linedata) + "\n\n"
    end
  end
end

module Compiler
  module_function

  def get_all_PBS_file_paths(game_data)
    ret = []
    game_data.each { |element| ret.push(element.pbs_file_suffix) if !ret.include?(element.pbs_file_suffix) }
    ret.each_with_index do |element, i|
      ret[i] = [sprintf("PBS/%s.txt", game_data::PBS_BASE_FILENAME), element]
      if !nil_or_empty?(element)
        ret[i][0] = sprintf("PBS/%s_%s.txt", game_data::PBS_BASE_FILENAME, element)
      end
    end
    return ret
  end

  def add_PBS_header_to_file(file)
    file.write(0xEF.chr)
    file.write(0xBB.chr)
    file.write(0xBF.chr)
    file.write("\# " + _INTL("See the documentation on the wiki to learn how to edit this file.") + "\r\n")
  end

  def write_PBS_file_generic(game_data)
    paths = get_all_PBS_file_paths(game_data)
    schema = game_data.schema
    idx = 0
    paths.each do |path|
      write_pbs_file_message_start(path[0])
      File.open(path[0], "wb") do |f|
        add_PBS_header_to_file(f)
        # Write each element in turn
        game_data.each do |element|
          next if element.pbs_file_suffix != path[1]
          echo "." if idx % 100 == 0
          Graphics.update if idx % 500 == 0
          idx += 1
          f.write("\#-------------------------------\r\n")
          if schema["SectionName"]
            f.write("[")
            pbWriteCsvRecord(element.get_property_for_PBS("SectionName"), f, schema["SectionName"])
            f.write("]\r\n")
          else
            f.write("[#{element.id}]\r\n")
          end
          schema.each_key do |key|
            next if key == "SectionName"
            val = element.get_property_for_PBS(key)
            next if val.nil?
            if schema[key][1][0] == "^" && val.is_a?(Array)
              val.each do |sub_val|
                f.write(sprintf("%s = ", key))
                pbWriteCsvRecord(sub_val, f, schema[key])
                f.write("\r\n")
              end
            else
              f.write(sprintf("%s = ", key))
              pbWriteCsvRecord(val, f, schema[key])
              f.write("\r\n")
            end
          end
        end
      end
      process_pbs_file_message_end
    end
  end

  def pbRaidEachFileSectionEx(f, schema = nil)
    lineno      = 1
    havesection = false
    sectionname = nil
    lastsection = {}
    f.each_line do |line|
      if lineno == 1 && line[0].ord == 0xEF && line[1].ord == 0xBB && line[2].ord == 0xBF
        line = line[3, line.length - 3]
      end
      line.force_encoding(Encoding::UTF_8)
      if !line[/^\#/] && !line[/^\s*$/]
        line = prepline(line)
        if line[/^\s*\[\s*(.*)\s*\]\s*$/]   # Of the format: [something]
          yield lastsection, sectionname if havesection
          sectionname = $~[1]
          havesection = true
          lastsection = {}
        else
          if sectionname.nil?
            FileLineData.setLine(line, lineno)
            raise _INTL("Expected a section at the beginning of the file. This error may also occur if the file was not saved in UTF-8.\n{1}", FileLineData.linereport)
          end
          if !line[/^\s*(\w+)\s*=\s*(.*)$/]
            FileLineData.setSection(sectionname, nil, line)
            raise _INTL("Bad line syntax (expected syntax like XXX=YYY)\n{1}", FileLineData.linereport)
          end
          r1 = $~[1]
          r2 = $~[2]
          if schema && schema[r1] && schema[r1][1][0] == "^"
            lastsection[r1] ||= []
            lastsection[r1].push(r2.gsub(/\s+$/, ""))
          else
            lastsection[r1] = r2.gsub(/\s+$/, "")
          end
        end
      end
      lineno += 1
      Graphics.update if lineno % 1000 == 0
    end
    yield lastsection, sectionname if havesection
  end

  def pbRaidEachFileSection(f, schema = nil)
    pbRaidEachFileSectionEx(f, schema) do |section, name|
      yield section, name if block_given? && name[/^.+$/]
    end
  end

  def pbRaidEachFileSectionNumbered(f, schema = nil)
    pbRaidEachFileSectionEx(f, schema) do |section, name|
      yield section, name.to_i if block_given? && name[/^\d+$/]
    end
  end

  def get_csv_record(rec, schema)
    ret = []
    repeat = false
    start = 0
    schema_length = schema[1].length
    case schema[1][0, 1]   # First character in schema
    when "*"
      repeat = true
      start = 1
    when "^"
      start = 1
      schema_length -= 1
    end
    subarrays = repeat && schema[1].length - start > 1   # Whether ret is an array of arrays
    # Split the string on commas into an array of values to apply the schema to
    values = split_csv_line(rec)
    # Apply the schema to each value in the line
    idx = -1   # Index of value to look at in values
    loop do
      record = []
      (start...schema[1].length).each do |i|
        idx += 1
        sche = schema[1][i, 1]
        if sche[/[A-Z]/]   # Upper case = optional
          if nil_or_empty?(values[idx])
            record.push(nil)
            next
          end
        end
        if sche.downcase == "q"   # Unformatted text
          record.push(rec)
          idx = values.length
          break
        else
          record.push(cast_csv_value(values[idx], sche, schema[2 + i - start]))
        end
      end
      if !record.empty?
        if subarrays
          ret.push(record)
        else
          ret.concat(record)
        end
      end
      break if !repeat || idx >= values.length - 1
    end
    return (!repeat && schema_length == 1) ? ret[0] : ret
  end

  def split_csv_line(string)
    # Split the string into an array of values, using a comma as the separator
    values = string.split(",")
    # Check for quote marks in each value, as we may need to recombine some values
    # to make proper results
    (0...values.length).each do |i|
      value = values[i]
      next if !value || value.empty?
      quote_count = value.count('"')
      if quote_count != 0
        # Quote marks found in value
        (i...(values.length - 1)).each do |j|
          quote_count = values[i].count('"')
          if quote_count == 2 && value.start_with?('\\"') && values[i].end_with?('\\"')
            # Two quote marks around the whole value; remove them
            values[i] = values[i][2..-3]
            break
          elsif quote_count.even?
            break
          end
          # Odd number of quote marks in value; concatenate the next value to it and
          # see if that's any better
          values[i] += "," + values[j + 1]
          values[j + 1] = nil
        end
        # Recheck for enclosing quote marks to remove
        if quote_count != 2
          if value.count('"') == 2 && value.start_with?('\\"') && value.end_with?('\\"')
            values[i] = values[i][2..-3]
          end
        end
      end
      # Remove leading and trailing whitespace from value
      values[i].strip!
    end
    # Remove nil values caused by concatenating values above
    values.compact!
    return values
  end

  def cast_csv_value(value, schema, enumer = nil)
    case schema.downcase
    when "i"   # Integer
      if !value[/^\-?\d+$/]
        raise _INTL("Field {1} is not an integer\n{2}", value, RaidFileLineData.linereport)
      end
      return value.to_i
    when "u"   # Positive integer or zero
      if !value[/^\d+$/]
        raise _INTL("Field {1} is not a positive integer or 0\n{2}", value, RaidFileLineData.linereport)
      end
      return value.to_i
    when "v"   # Positive integer
      if !value[/^\d+$/]
        raise _INTL("Field {1} is not a positive integer\n{2}", value, RaidFileLineData.linereport)
      end
      if value.to_i == 0
        raise _INTL("Field '{1}' must be greater than 0\n{2}", value, RaidFileLineData.linereport)
      end
      return value.to_i
    when "x"   # Hexadecimal number
      if !value[/^[A-F0-9]+$/i]
        raise _INTL("Field '{1}' is not a hexadecimal number\n{2}", value, RaidFileLineData.linereport)
      end
      return value.hex
    when "f"   # Floating point number
      if !value[/^\-?^\d*\.?\d*$/]
        raise _INTL("Field {1} is not a number\n{2}", value, RaidFileLineData.linereport)
      end
      return value.to_f
    when "b"   # Boolean
      return true if value[/^(?:1|TRUE|YES|Y)$/i]
      return false if value[/^(?:0|FALSE|NO|N)$/i]
      raise _INTL("Field {1} is not a Boolean value (true, false, 1, 0)\n{2}", value, RaidFileLineData.linereport)
    when "n"   # Name
      if !value[/^(?![0-9])\w+$/]
        raise _INTL("Field '{1}' must contain only letters, digits, and\nunderscores and can't begin with a number.\n{2}", value, RaidFileLineData.linereport)
      end
    when "s"   # String
    when "q"   # Unformatted text
    when "m"   # Symbol
      if !value[/^(?![0-9])\w+$/]
        raise _INTL("Field '{1}' must contain only letters, digits, and\nunderscores and can't begin with a number.\n{2}", value, RaidFileLineData.linereport)
      end
      return value.to_sym
    when "e"   # Enumerable
      return checkEnumField(value, enumer)
    when "y"   # Enumerable or integer
      return value.to_i if value[/^\-?\d+$/]
      return checkEnumField(value, enumer)
    end
    return value
  end

  # Primary Compiler
  def compile_PBS_file_generic(game_data, *paths)
    if game_data.const_defined?(:OPTIONAL) && game_data::OPTIONAL
      return if paths.none? { |p| FileTest.exist?(p) }
    end
    game_data::DATA.clear
    schema = game_data.schema
    # Read from PBS file(s)
    paths.each do |path|
      compile_pbs_file_message_start(path)
      base_filename = game_data::PBS_BASE_FILENAME
      base_filename = base_filename[0] if base_filename.is_a?(Array)   # For Species
      file_suffix = File.basename(path, ".txt")[base_filename.length + 1, path.length] || ""
      File.open(path, "rb") do |f|
        FileLineData.file = path   # For error reporting
        # Read a whole section's lines at once, then run through this code.
        # contents is a hash containing all the XXX=YYY lines in that section, where
        # the keys are the XXX and the values are the YYY (as unprocessed strings).
        idx = 0
        pbRaidEachFileSection(f, schema) do |contents, section_name|
          echo "." if idx % 100 == 0
          Graphics.update if idx % 500 == 0
          idx += 1
          data_hash = {
            :id              => section_name.to_sym,
            :pbs_file_suffix => file_suffix
          }
          # Go through schema hash of compilable data and compile this section
          schema.each_key do |key|
            FileLineData.setSection(section_name, key, contents[key])   # For error reporting
            if key == "SectionName"
              data_hash[schema[key][0]] = get_csv_record(section_name, schema[key])
              next
            end
            # Skip empty properties
            next if contents[key].nil?
            # Compile value for key
            if schema[key][1][0] == "^"
              contents[key].each do |val|
                value = get_csv_record(val, schema[key])
                value = nil if value.is_a?(Array) && value.empty?
                data_hash[schema[key][0]] ||= []
                data_hash[schema[key][0]].push(value)
              end
              data_hash[schema[key][0]].compact!
            else
              value = get_csv_record(contents[key], schema[key])
              value = nil if value.is_a?(Array) && value.empty?
              data_hash[schema[key][0]] = value
            end
          end
          # Validate and modify the compiled data
          yield false, data_hash if block_given?
          if game_data.exists?(data_hash[:id])
            raise _INTL("Section name '{1}' is used twice.\n{2}", data_hash[:id], FileLineData.linereport)
          end
          # Add section's data to records
          game_data.register(data_hash)
        end
      end
      process_pbs_file_message_end
    end
    yield true, nil if block_given?
    # Save all data
    game_data.save
  end

  def get_all_pbs_files_to_compile
    # Get the GameData classes and their respective base PBS filenames
    ret = GameData.get_all_pbs_base_filenames
    ret.merge!({
      :BattleFacility => "battle_facility_lists",
      :Connection     => "map_connections",
      :RegionalDex    => "regional_dexes"
    })
    ret.each { |key, val| ret[key] = [val] }   # [base_filename, ["PBS/file.txt", etc.]]
    # Look through all PBS files and match them to a GameData class based on
    # their base filenames
    text_files_keys = ret.keys.sort! { |a, b| ret[b][0].length <=> ret[a][0].length }
    Dir.chdir("PBS/") do
      Dir.glob("*.txt") do |f|
        base_name = File.basename(f, ".txt")
        text_files_keys.each do |key|
          next if base_name != ret[key][0] && !f.start_with?(ret[key][0] + "_")
          ret[key][1] ||= []
          ret[key][1].push("PBS/" + f)
          break
        end
      end
    end
    return ret
  end
end
