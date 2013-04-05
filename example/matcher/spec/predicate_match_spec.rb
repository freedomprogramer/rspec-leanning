require 'helper_spec' 

class Team
  def self.players_name
    ["joe", "Lee"]
  end
end

describe Array do
  context "with no items" do
    before{ @no_item = [] }
    
    it "which lenght should be 0" do
      @no_item.should have(0).items
    end
  end

  context "with some items" do
    it "have elements, which are not eq 0" do
      @true_item = [1, "hello world"]

      expect(@true_item.first).to be_true
      expect(@true_item.last).to be_true
    end

    it "have some elements, which are eq to 0" do
      @false_items = [false, ""]
      
      expect(@false_items.first).to be_false
      expect(@false_items.last).to be_true
    end
  end
end

describe Team do
  describe "#players_name" do
    it "should return a array with some names" do
      Team.should have(2).players_name
    end
  end
end
