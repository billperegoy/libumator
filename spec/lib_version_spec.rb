require_relative "./spec_helper"

describe LibVersion do
  let (:elem) { LibVersion.new(vendor: 'xilinx', vendor_version: 'vivado.2015.1',
                               family: 'series7', sim_version: 'incisive.142_s007',
                               word_size: 32)
  }

  it "should accept validate argumnents and create a lib version" do
    expect(elem.vendor).to eq('xilinx')
    expect(elem.vendor_version).to eq('vivado.2015.1')
    expect(elem.family).to eq('series7')
    expect(elem.sim_version).to eq('incisive.142_s007')
    expect(elem.word_size).to eq(32)
  end

  it "should be able to return a proper hash key for a lib version" do
    expect(elem.hash_key).to eq('xilinx:vivado.2015.1:series7:incisive.142_s007:32')
  end
end
