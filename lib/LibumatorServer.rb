class LibumatorServer
  attr_reader :existing_libs, :job_runner

  def initialize(reader:, job_runner:)
    @reader = reader
    @job_runner = job_runner

    @existing_libs = reader.read_dirs
  end

  def exist_lib?(lib)
    @existing_libs.has_key?(lib.hash_key)
  end

  def build_status(lib)
    @existing_libs[lib.hash_key] and @existing_libs[lib.hash_key].status
  end

  def build_path(lib)
    @existing_libs[lib.hash_key] and @existing_libs[lib.hash_key].path
  end

  def build_lib(lib)
    unless exist_lib?(lib)
      info = LibInfo.new(status: :build_in_progress,
                         path: "/hwnet/some/broken/shit/32")
      @existing_libs[lib.hash_key] = info
      @job_runner.start_job(lib)
    end
  end
end
