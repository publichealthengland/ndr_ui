require 'test_helper'

# Test bootstrap form builder input group addons
class InputGroupAddonsTest < ActionView::TestCase
  tests ActionView::Helpers::FormHelper
  include NdrUi::BootstrapHelper

  test 'text_field with prepend' do
    post = Post.new
    bootstrap_form_for post do |form|
      assert_dom_equal(
        '<div class="input-group">' \
        '<span class="input-group-text">apples</span>' \
        '<input id="post_id" name="post[id]" class="form-control" type="text" />' \
        '</div>' \
        '<span class="form-text" data-feedback-for="post_id">' \
        '<span class="text-danger"></span>' \
        '<span class="text-warning"></span>' \
        '</span>',
        form.text_field(:id, prepend: 'apples')
      )
    end
  end

  test 'text_field with append' do
    post = Post.new
    bootstrap_form_for post do |form|
      assert_dom_equal(
        '<div class="input-group">' \
        '<input id="post_id" name="post[id]" class="form-control" type="text" />' \
        '<span class="input-group-text">pears</span>' \
        '</div>' \
        '<span class="form-text" data-feedback-for="post_id">' \
        '<span class="text-danger"></span>' \
        '<span class="text-warning"></span>' \
        '</span>',
        form.text_field(:id, append: 'pears')
      )
    end
  end

  test 'text_field with prepend and append' do
    post = Post.new
    bootstrap_form_for post do |form|
      assert_dom_equal(
        '<div class="input-group">' \
        '<span class="input-group-text">apples</span>' \
        '<input id="post_id" name="post[id]" class="form-control" type="text" />' \
        '<span class="input-group-text">pears</span>' \
        '</div>' \
        '<span class="form-text" data-feedback-for="post_id">' \
        '<span class="text-danger"></span>' \
        '<span class="text-warning"></span>' \
        '</span>',
        form.text_field(:id, prepend: 'apples', append: 'pears')
      )
    end
  end
end
