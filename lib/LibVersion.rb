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
    "#{@vendor}:#{@vendor_version}:#{@family}:#{@sim_version}:#{@word_size}"
  end

  def path
    sim_version_xformed = @sim_version.sub(/incisiv/, 'ICS_')
    "/hwnet/libraries/#{@vendor}/#{@vendor_version}/#{sim_version_xformed}/#{@family}/#{@word_size}"
  end
end
