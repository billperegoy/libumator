class LibInfo
  attr_reader :status, :path

  def initialize(status:, path:)
    @status = status
    @path = path
  end
end
