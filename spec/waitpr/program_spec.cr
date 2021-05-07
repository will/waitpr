require "../spec_helper"

describe WaitPR::Program, "notify_cutoff=" do
  it "rejects non numbers" do
    result = WaitPR::Program.new.notify_cutoff = "blah"
    result.should_not be_nil
  end

  it "rejects negative numbers" do
    result = WaitPR::Program.new.notify_cutoff = "-1"
    result.should_not be_nil
  end

  it "accepts zero and higher" do
    prog = WaitPR::Program.new
    (prog.notify_cutoff = "0").should be_nil
    prog.notify_cutoff.should eq 0.seconds

    (prog.notify_cutoff = "1").should be_nil
    prog.notify_cutoff.should eq 1.seconds

    (prog.notify_cutoff = "143").should be_nil
    prog.notify_cutoff.should eq 143.seconds
  end
end
