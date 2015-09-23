class LibVersion
  attr_reader :vendor, :vendor_version, :family, :sim_version, :word_size

  def initialize(vendor:, vendor_version:, family:, sim_version:, word_size:)
    @vendor = vendor
    @vendor_version = vendor_version
    @family = family
    @sim_version = sim_version
    @word_size = word_size
  end

  def hash_key
    "#{vendor}:#{vendor_version}:#{family}:#{sim_version}:#{word_size}"
  end
end
