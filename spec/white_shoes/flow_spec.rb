require "spec_helper"

require 'white_shoes'

describe WhiteShoes::Flow do
  
  it_behaves_like "A WhiteShoes Shoes::Flow"

  #
  #let(:display) { SWT::Widgets::Display.getDefault }
  #let(:parent_container) { SWT::Widgets::Shell.new(display) }
  #
  #it "should have a SWT Composite" do
  #  flow = Shoes::Flow.new(parent_container)
  #  flow.container.should be_a SWT::Layouts::Composite
  #end
  #
  #it "should horizontally stack 3 widgets" do
  #  button1 = button2 = button3 = nil
  #  Shoes::Flow.new(parent_container) do
  #    button1 = button("Button1")
  #    button2 = button("Button2")
  #    button3 = button("Button3")
  #  end
  #  button1.left.should >= 0
  #  button2.left.should >= button1.left + button1.width
  #end
  #
  #it "should have a margin" do
  #  button1 = nil
  #  flow = Shoes::Flow.new(parent_container, :margin => 10) do
  #    button1 = button("Button1")
  #  end
  #  button1.top.should == 10
  #  button1.left.should == 10
  #end
  #
  #after :all do
  #  SWT::Widgets::Display.getDefault.dispose
  #end

end