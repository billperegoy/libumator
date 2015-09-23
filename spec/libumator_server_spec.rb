require_relative "./spec_helper"

describe LibumatorServer do
  let(:lib_dir_reader) { double("lib_reader", 
                                :read_dirs => {
                                  "xilinx:vivado.2015.1:series7:incisive.142_s007:32" => {
                                    status: :build_success,
                                    path: "/hwnet/some/shit/32"
                                  },
                                  "xilinx:vivado.2015.1:series7:incisive.142_s007:64" => {
                                    status: :build_success,
                                    path: "/hwnet/some/shit/64"
                                  },
                                  "xilinx:vivado.2015.2:series7:incisive.142_s007:32" => {
                                    status: :build_success,
                                    path: "/hwnet/some/shit/32"
                                  }
                                }
                               ) 
  }
    
  def lib_hash_factory(vendor: 'xilinx', vendor_version: 'vivado.2015.1',
               family: 'series7', sim_version: 'incisive.142_s007',
               word_size: 32)
    {
      vendor: vendor, vendor_version: vendor_version,
      family: family, sim_version: sim_version, word_size: word_size
    }
  end

  let (:good_lib_hash) { lib_hash_factory }
  let (:bad_lib_hash) { lib_hash_factory(vendor: 'bogus') }

  it "Should initialize by reading status of all existing libs" do
     server = LibumatorServer.new(reader: lib_dir_reader)
     expect(server.existing_libs.length).to eq(3)
  end

  it "should accept a exist_lib? method and return true if it exists" do
     server = LibumatorServer.new(reader: lib_dir_reader)
     response = server.exist_lib?(good_lib_hash)
     expect(response).to eq(true)
  end

  it "should accept a exist_lib? method and return false if it does not exist" do
     server = LibumatorServer.new(reader: lib_dir_reader)
     response = server.exist_lib?(bad_lib_hash)
     expect(response).to eq(false)
  end

  it "should properly build status for an existing library" do
     server = LibumatorServer.new(reader: lib_dir_reader)
     expect(server.build_status(good_lib_hash)).to eq (:build_success)
  end

  it "should return nil build status for a non-existent library" do
     server = LibumatorServer.new(reader: lib_dir_reader)
     expect(server.build_status(bad_lib_hash)).to eq (nil)
  end
end
