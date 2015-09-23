class LibumatorServer
  attr_reader :existing_libs

  def initialize(reader:)
    @reader = reader
    @existing_libs = reader.read_dirs
  end

  def exist_lib?(vendor:, vendor_version:, family:, sim_version:, word_size:)
    key = "#{vendor}:#{vendor_version}:#{family}:#{sim_version}:#{word_size}"
    @existing_libs.has_key?(key)
  end

  def build_status(vendor:, vendor_version:, family:, sim_version:, word_size:)
    key = "#{vendor}:#{vendor_version}:#{family}:#{sim_version}:#{word_size}"
    @existing_libs[key] and @existing_libs[key][:status]
  end

  private
  # FIXME - This should be facored out but it's messier after
  # extracting a method. Does it make sense to extract a class?
  # In that case the input to these methods would be an instance of
  # the hash key class.
  def hash_key(vendor:, vendor_version:, family:, sim_version:, word_size:)
    "#{vendor}:#{vendor_version}:#{family}:#{sim_version}:#{word_size}"
  end
end
