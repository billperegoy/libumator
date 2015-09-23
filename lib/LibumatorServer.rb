class LibumatorServer
  attr_reader :existing_libs, :job_runner

  def initialize(reader:, job_runner:)
    @reader = reader
    @job_runner = job_runner

    @existing_libs = reader.read_dirs
  end

  def exist_lib?(lib)
    key = lib.hash_key
    @existing_libs.has_key?(key)
  end

  def build_status(lib)
    key = lib.hash_key
    @existing_libs[key] and @existing_libs[key][:status]
  end

  def build_path(lib)
    key = lib.hash_key
    @existing_libs[key] and @existing_libs[key][:path]
  end

  def build_lib(lib)
    key = lib.hash_key
    unless exist_lib?(lib)
      @existing_libs[lib.hash_key] =  { status: :build_in_progress,
                                        path: "/hwnet/some/broken/shit/32"
                                      }
      @job_runner.start_job(lib)
    end
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
