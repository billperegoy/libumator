require_relative './spec_helper'

describe LibInfo do
  it "allows creation of a LibInfo object" do
    info = LibInfo.new(status: :build_success, path: '/hwnet/some/shit/32')
    expect(info.status).to eq(:build_success)
    expect(info.path).to eq('/hwnet/some/shit/32')
  end
end
