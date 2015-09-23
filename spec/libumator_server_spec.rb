require_relative "./spec_helper"

describe LibumatorServer do
  let(:good_lib1) { LibVersion.new(vendor: 'xilinx', vendor_version: 'vivado.2015.1',
                              family: 'series7', sim_version: 'incisive.142_s007',
                              word_size: 32)
  }

  let(:good_lib2) { LibVersion.new(vendor: 'xilinx', vendor_version: 'vivado.2015.1',
                              family: 'series7', sim_version: 'incisive.142_s007',
                              word_size: 64)
  }
  let(:good_lib3) { LibVersion.new(vendor: 'xilinx', vendor_version: 'vivado.2015.2',
                              family: 'series7', sim_version: 'incisive.142_s007',
                              word_size: 32)
  }

  let(:bad_lib) { LibVersion.new(vendor: 'xilinx', vendor_version: 'vivado.2015.1',
                              family: 'bogus', sim_version: 'incisive.142_s007',
                              word_size: 32)
  }

  let(:new_lib) { LibVersion.new(vendor: 'xilinx', vendor_version: 'vivado.2015.1',
                              family: 'kintex7', sim_version: 'incisive.142_s007',
                              word_size: 32)
  }

  let(:lib_dir_reader) { double("lib_reader", 
                                :read_dirs => {
                                  good_lib1.hash_key => {
                                    status: :build_success,
                                    path: '/hwnet/some/shit/32'
                                  },
                                  good_lib2.hash_key => {
                                    status: :build_success,
                                    path: '/hwnet/some/shit/64'
                                  },
                                  good_lib3.hash_key => {
                                    status: :build_success,
                                    path: '/hwnet/some/other/shit/32'
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


  it "Should initialize by reading status of all existing libs" do
    expect(server.existing_libs.length).to eq(3)
  end

  it "should accept a exist_lib? method and return true if it exists" do
    response = server.exist_lib?(good_lib1)
    expect(response).to eq(true)
  end

  it "should accept a exist_lib? method and return false if it does not exist" do
    response = server.exist_lib?(bad_lib)
    expect(response).to eq(false)
  end

  it "should properly return build status for an existing library" do
    expect(server.build_status(good_lib1)).to eq (:build_success)
  end

  it "should return nil build status for a non-existent library" do
    expect(server.build_status(bad_lib)).to eq (nil)
  end

  it "should properly return lib path for an existing library" do
    expect(server.build_path(good_lib1)).to eq ('/hwnet/some/shit/32')
  end

  it "should return nil path for a non-existent library" do
    expect(server.build_path(bad_lib)).to eq (nil)
  end

  it "should set status to :build_in_progress if new libray is requested to be built" do
    server.build_lib(new_lib)
    expect(server.build_status(new_lib)).to eq (:build_in_progress)
  end

  it "should not change status if we try to buil an existing lib" do
    start_status = server.build_status(good_lib1)
    server.build_lib(good_lib1)
    expect(server.build_status(good_lib1)).to eq (start_status)
  end

  it "should kick off the lib build process if all is well on build command" do
    server.build_lib(new_lib)
    expect(server.job_runner).to have_received(:start_job)
  end
end
