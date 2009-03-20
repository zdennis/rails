require File.join(File.expand_path(File.dirname(__FILE__)), "test_helper")

module HappyPath
  
  class RenderTextController < ActionController::Base2
    self.view_paths = [ActionView::FixtureTemplate::FixturePath.new(
      "layouts/application.html.erb" => "<%= yield %>, I'm here!",
      "layouts/greetings.html.erb"   => "<%= yield %>, I wish thee well."
    )]
    
    def render_hello_world_from_variable
      render :text => "hello david"
    end
    
    def render_custom_code
      render :text => "hello world", :status => 404
    end
    
    def render_with_custom_code_as_string
      render :text => "hello world", :status => "404 Not Found"
    end
    
    def render_text_with_nil
      render :text => nil
    end
    
    def render_text_with_nil_and_status
      render :text => nil, :status => 403
    end

    def render_text_with_false
      render :text => false
    end
    
    def render_text_with_layout
      render :text => "hello world", :layout => true
    end
    
    def render_text_with_custom_layout
      render :text => "hello world", :layout => "greetings"
    end
  end
  
  class TestSimpleTextRender < SimpleRouteCase    
    describe "Rendering text from a action with default options renders the text without the layout"
    
    get "/happy_path/render_text/render_hello_world_from_variable"
    assert_body   "hello david"
    assert_status 200
  end
  
  class TestTextRenderWithStatus < SimpleRouteCase
    describe "Rendering text, while also providing a custom status code"
    
    get "/happy_path/render_text/render_custom_code"
    assert_body   "hello world"
    assert_status 404
  end
  
  class TestTextRenderWithNil < SimpleRouteCase
    describe "Rendering text with nil returns a single space character"
    
    get "/happy_path/render_text/render_text_with_nil"
    assert_body   " "
    assert_status 200
  end
  
  class TestTextRenderWithNilAndStatus < SimpleRouteCase
    describe "Rendering text with nil and custom status code returns a single space character with the status"
    
    get "/happy_path/render_text/render_text_with_nil_and_status"
    assert_body   " "
    assert_status 403
  end
  
  class TestTextRenderWithFalse < SimpleRouteCase
    describe "Rendering text with false returns the string 'false'"
    
    get "/happy_path/render_text/render_text_with_false"
    assert_body   "false"
    assert_status 200
  end
  
  class TestTextRenderWithLayoutTrue < SimpleRouteCase
    describe "Rendering text with :layout => true"
    
    get "/happy_path/render_text/render_text_with_layout"
    assert_body "hello world, I'm here!"
    assert_status 200
  end
  
  class TestTextRenderWithCustomLayout < SimpleRouteCase
    describe "Rendering text with :layout => 'greetings'"
    
    get "/happy_path/render_text/render_text_with_custom_layout"
    assert_body "hello world, I wish thee well."
    assert_status 200
  end
end