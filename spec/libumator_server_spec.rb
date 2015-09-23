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
                                    path: "/hwnet/some/new/shit/32"
                                  }
                                }
                               ) 
  }

  let(:job_runner) { double("job_runner", start_job: nil) }
  let(:server) {  LibumatorServer.new(reader: lib_dir_reader, job_runner: job_runner) }
    
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
  let (:new_lib_hash) { lib_hash_factory(family: 'kintex7') }

  it "Should initialize by reading status of all existing libs" do
    expect(server.existing_libs.length).to eq(3)
  end

  it "should accept a exist_lib? method and return true if it exists" do
    response = server.exist_lib?(good_lib_hash)
    expect(response).to eq(true)
  end

  it "should accept a exist_lib? method and return false if it does not exist" do
    response = server.exist_lib?(bad_lib_hash)
    expect(response).to eq(false)
  end

  it "should properly return build status for an existing library" do
    expect(server.build_status(good_lib_hash)).to eq (:build_success)
  end

  it "should return nil build status for a non-existent library" do
    expect(server.build_status(bad_lib_hash)).to eq (nil)
  end

  it "should properly return lib path for an existing library" do
    expect(server.build_path(good_lib_hash)).to eq ('/hwnet/some/shit/32')
  end

  it "should return nil path for a non-existent library" do
    expect(server.build_path(bad_lib_hash)).to eq (nil)
  end

  it "should set status to :build_in_progress if new libray is requested to be built" do
    server.build_lib(new_lib_hash)
    expect(server.build_status(new_lib_hash)).to eq (:build_in_progress)
  end

  it "should not change status if we try to buil an existing lib" do
    start_status = server.build_status(good_lib_hash)
    server.build_lib(good_lib_hash)
    expect(server.build_status(good_lib_hash)).to eq (start_status)
  end

  it "should kick off the lib build process if all is well on build command" do
    server.build_lib(new_lib_hash)
    expect(server.job_runner).to have_received(:start_job)
  end
end
