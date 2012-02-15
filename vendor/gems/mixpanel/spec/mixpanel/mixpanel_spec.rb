require 'spec_helper'

describe Mixpanel do
  before do
    @mixpanel = Mixpanel.new(MIX_PANEL_TOKEN, @env = {"REMOTE_ADDR" => "127.0.0.1"})
  end

  context "Initializing object" do
    it "should have an instance variable for token and events" do
      @mixpanel.instance_variables.should include("@token", "@env")
    end
  end

  context "Cleaning appended events" do
    it "should clear the queue" do
      @mixpanel.append_event("Sign up")
      @mixpanel.queue.size.should == 1
      @mixpanel.clear_queue
      @mixpanel.queue.size.should == 0
    end
  end

  context "Accessing Mixpanel through direct request" do
    context "Tracking events" do
      it "should track simple events" do
        @mixpanel.track_event("Sign up").should == true
      end

      it "should call request method with token and time value" do
        params = {:event => "Sign up", :properties => {:token => MIX_PANEL_TOKEN, :time => Time.now.utc.to_i, :ip => "127.0.0.1"}}

        @mixpanel.should_receive(:request).with(params).and_return("1")
        @mixpanel.track_event("Sign up").should == true
      end
    end
  end

  context "Accessing Mixpanel through javascript API" do
    context "Appending events" do
      it "should store the event under the appropriate key" do
        @mixpanel.append_event("Sign up")
        @env.has_key?("mixpanel_events").should == true
      end

      it "should be the same the queue than env['mixpanel_events']" do
        @env['mixpanel_events'].object_id.should == @mixpanel.queue.object_id
      end

      it "should append simple events" do
        @mixpanel.append_event("Sign up")
        mixpanel_queue_should_include(@mixpanel, "track", "Sign up", {})
      end

      it "should append events with properties" do
        @mixpanel.append_event("Sign up", {:referer => 'http://example.com'})
        mixpanel_queue_should_include(@mixpanel, "track", "Sign up", {:referer => 'http://example.com'})
      end

      it "should give direct access to queue" do
        @mixpanel.append_event("Sign up", {:referer => 'http://example.com'})
        @mixpanel.queue.size.should == 1
      end
      
      it "should provide direct access to the JS api" do
        @mixpanel.append_api('track', "Sign up", {:referer => 'http://example.com'})
        mixpanel_queue_should_include(@mixpanel, "track", "Sign up", {:referer => 'http://example.com'})
      end
      
      it "should allow identify to be called through the JS api" do
        @mixpanel.append_api('identify', "some@one.com")
        mixpanel_queue_should_include(@mixpanel, "identify", "some@one.com")
      end

      it "should allow identify to be called through the JS api" do
        @mixpanel.append_api('identify', "some@one.com")
        mixpanel_queue_should_include(@mixpanel, "identify", "some@one.com")
      end
      
      it "should allow the tracking of super properties in JS" do
        @mixpanel.append_api('register', {:user_id => 12345, :email => "some@one.com"})
        mixpanel_queue_should_include(@mixpanel, 'register', {:user_id => 12345, :email => "some@one.com"})
      end
    end
  end
end
