require 'test_helper'

# Test bootstrap form builder inline errors
class InlineErrorsAndWarningsTest < ActionView::TestCase
  tests ActionView::Helpers::FormHelper
  include NdrUi::BootstrapHelper

  test 'should create alias feature methods' do
    post = Post.new

    bootstrap_form_for post do |form|
      assert form.respond_to?(:text_field_with_inline_errors)
      assert form.respond_to?(:text_field_without_inline_errors)

      assert form.respond_to?(:collection_select_with_inline_errors)
      assert form.respond_to?(:collection_select_without_inline_errors)

      assert form.respond_to?(:time_select_with_inline_errors)
      assert form.respond_to?(:time_select_without_inline_errors)

      refute form.respond_to?(:hidden_field_with_inline_errors)
      refute form.respond_to?(:hidden_field_without_inline_errors)
    end
  end

  test 'each field should have a single form-text' do
    post = Post.new

    bootstrap_form_for post do |form|
      assert_dom_equal(
        '<input class="form-control" type="text" name="post[created_at]" id="post_created_at" />' \
        '<span class="form-text" data-feedback-for="post_created_at">' \
        '<span class="text-danger"></span><span class="text-warning"></span>' \
        '</span>',
        form.text_field(:created_at)
      )
    end
  end

  test 'should wrap form-text when fields_for a collections' do
    post = Post.new

    form_for post do |form|
      assert_dom_equal(
        '<input type="text" name="post[sub_records][][created_at]" id="post_sub_records__created_at" />',
        form.fields_for('sub_records[]', Post.new) do |sub_form|
          sub_form.text_field(:created_at)
        end
      )
    end

    bootstrap_form_for post do |form|
      assert_dom_equal(
        '<input class="form-control" type="text" name="post[sub_records][][created_at]" id="post_sub_records__created_at" />' \
        '<span class="form-text" data-feedback-for="post_sub_records__created_at">' \
        '<span class="text-danger"></span>' \
        '<span class="text-warning"></span>' \
        '</span>',

        form.fields_for('sub_records[]', Post.new) do |sub_form|
          sub_form.text_field(:created_at)
        end
      )
    end
  end

  test 'should display warnings' do
    post = Post.new
    post.warnings.add(:created_at, 'some')
    post.warnings.add(:created_at, 'message')

    bootstrap_form_for post do |form|
      assert_dom_equal(
        '<input class="form-control" type="text" name="post[created_at]" id="post_created_at" />' \
        '<span class="form-text" data-feedback-for="post_created_at">' \
        '<span class="text-danger"></span><span class="text-warning">some<br>message</span>' \
        '</span>',
        form.text_field(:created_at)
      )
    end
  end

  test 'should display errors' do
    post = Post.new
    post.errors.add(:created_at, 'not')
    post.errors.add(:created_at, 'great')

    bootstrap_form_for post do |form|
      assert_dom_equal(
        '<input class="form-control" type="text" name="post[created_at]" id="post_created_at" />' \
        '<span class="form-text" data-feedback-for="post_created_at">' \
        '<span class="text-danger">not<br>great</span><span class="text-warning"></span>' \
        '</span>',
        form.text_field(:created_at)
      )
    end
  end

  test 'should display errors when readonly' do
    post = Post.new(created_at: Date.new(2001, 2, 3))
    post.errors.add(:created_at, 'wrong')

    bootstrap_form_for post, readonly: true do |form|
      assert form.readonly?
      assert_dom_equal(
        '<p class="form-control-plaintext">2001-02-03 00:00:00 UTC</p>' \
        '<span class="form-text" data-feedback-for="post_created_at">' \
        '<span class="text-danger">wrong</span><span class="text-warning"></span>' \
        '</span>',
        form.text_field(:created_at)
      )
    end
  end

  test 'should handle basic objects' do
    post = Post.new

    expected = <<~HTML.strip
      <input class="form-control" type="text" name="post[banner_image][url]"
      id="post_banner_image_url" /><span class="form-text"
      data-feedback-for="post_banner_image_url"></span>
    HTML

    bootstrap_form_for post do |form|
      assert_dom_equal(expected, form.fields_for(:banner_image) { |sub| sub.text_field(:url) })
    end
  end
end
