require File.expand_path('../../test_helper', __FILE__)

class DocumentCategoriesRenderTest < ActiveSupport::TestCase
  def setup
    @category = create(:category)
    @stub = build(:category)
  end

  test("categories for name") do
    # Set the fixtures.
    template_content = <<-EOF
{% for category in document.categories %}
{{ category.name }}
{% endfor %}
EOF
    template_content = template_content.strip # FIXME: required?
    
    template = create(:template, :content => template_content)
    document = create(:document, {
      :categories => create_list(:category, 3),
      :template => template
    })
    
    # Check the fixtures.
    assert_equal template, document.document_template
    assert_equal 3, document.categories.size
    
    # Fire!
    document.render_fresh.first.tap do |output|
      # FIXME: Is there something better than #reject?
      output = output.split("\n").reject(&:blank?).compact.join("\n")
      
      # Check the fire.
      assert_equal document.categories.names.join("\n"), output
    end
  end
  test("categories slug") do
    # Set the fixtures.
    template_content = '{{ document.categories.first.slug }}'
    template_content = template_content.strip # FIXME: required?
    
    template = create(:template, :content => template_content)
    document = create(:document, {
      :categories => [create(:category, :slug => 'catwalk')],
      :template => template
    })
    
    # Check the fixtures.
    assert_equal template, document.document_template
    assert_equal 1, document.categories.size
    
    # Fire!
    document.render_fresh.first.tap do |output|
      # Check the fire.
      assert_equal 'catwalk', output
    end
  end
  test("primary_category") do
    # Set the fixtures.
    template_content = '{{ document.category.slug }}'
    template_content = template_content.strip # FIXME: required?
    
    category = create(:category, :slug => 'catwalk')
    
    template = create(:template, :content => template_content)
    document = create(:document, {
      :category => category,
      :template => template
    })
    
    # Check the fixtures.
    assert_equal template, document.document_template
    assert_equal 1, document.categories.size
    assert_equal category, document.primary_category
    
    # Fire!
    document.render_fresh.first.tap do |output|
      # Check the fire.
      assert_equal 'catwalk', output
    end
  end
end
