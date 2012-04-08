require 'swt_shoes/spec_helper'

describe SwtShoes::Shape do

  class ShapeShoeLaces
    include SwtShoes::Shape
    attr_accessor :gui_container
    attr_reader :gui_element
    attr_reader :blk
    attr_reader :width, :height
    def initialize(opts = {}, blk = nil )
      @opts = opts
      gui_init
    end
  end

  let(:gui_container) { double('gui_container', add_paint_listener: "Paint Listener") }
  let(:gui_element) { double('gui_element') }
  let(:args_with_element) { {container: gui_container, element: gui_element} }
  let(:args_without_element) { {container: gui_container} }

  shared_examples_for "Swt::Shape" do
    before :each do
      gui_element.stub(:move_to)
    end

    it "uses Swt and not White Shoes" do
      ancestors = subject.class.ancestors.map(&:name)
      ancestors.should include('SwtShoes::Shape')
      ancestors.should_not include('WhiteShoes::Shape')
      subject
    end

    its(:gui_container) { should be(gui_container) }
  end

  context "with gui container and gui element" do
    subject { ShapeShoeLaces.new gui: args_with_element }

    it_behaves_like "Swt::Shape"

    describe "gui_init" do
      it "should set current point on gui element" do
        gui_element.should_receive(:move_to)
        subject
      end
    end
  end

  context "with gui container only" do
    subject { ShapeShoeLaces.new gui: args_without_element }

    it_behaves_like "Swt::Shape"

    describe "gui_init" do
      it "should not set current point on gui element" do
        gui_element.should_not_receive(:move_to)
      end
    end
  end
end
