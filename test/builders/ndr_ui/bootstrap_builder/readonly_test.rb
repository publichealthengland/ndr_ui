require 'test_helper'

# Test bootstrap form builder readonly behaviour
class ReadonlyTest < ActionView::TestCase
  tests ActionView::Helpers::FormHelper
  include NdrUi::BootstrapHelper

  test 'readonly should not be the default' do
    post = Post.new
    bootstrap_form_for post do |form|
      refute form.readonly?
    end
  end

  test 'readonly should be settable' do
    post = Post.new
    bootstrap_form_for post do |form|
      form.readonly = true
      assert form.readonly?
    end

    bootstrap_form_for post, readonly: true do |form|
      assert form.readonly?
    end
  end

  test 'readonly should propagate down to fields_for' do
    post = Post.new
    bootstrap_form_for post, readonly: true do |form|
      form.fields_for(:sub_records) do |sub_form|
        assert sub_form.readonly?
      end
    end
  end

  test 'readonly should not propagate up from fields_for' do
    post = Post.new
    bootstrap_form_for post do |form|
      form.fields_for(:sub_records) do |sub_form|
        sub_form.readonly = true
        assert sub_form.readonly?
        refute form.readonly?
      end
    end

    bootstrap_form_for post do |form|
      form.fields_for(:sub_records, nil, readonly: true) do |sub_form|
        assert sub_form.readonly?
        refute form.readonly?
      end
    end
  end

  test 'readonly fields should show value instead' do
    time = Time.current
    post = Post.new(created_at: time)

    @output_buffer =
      bootstrap_form_for post do |form|
        form.text_field :created_at
      end

    assert_select 'input[type=text]#post_created_at'
    assert_select 'p.form-control-plaintext', 0

    reset_output_buffer!
    @output_buffer =
      bootstrap_form_for post, readonly: true do |form|
        form.text_field :created_at
      end
    assert_select 'input[type=text]#post_created_at', 0
    assert_select 'p.form-control-plaintext', text: time.to_s
  end

  test 'readonly fields should show custom value if given' do
    post = Post.new(created_at: Time.current)
    text = 'nothing here'

    @output_buffer =
      bootstrap_form_for post, readonly: true do |form|
        form.text_field :created_at, readonly_value: text
      end
    assert_select 'input[type=text]#post_created_at', 0
    assert_select 'p.form-control-plaintext', text: text.to_s
  end

  test 'hidden fields should not display in readonly' do
    time = Time.current
    post = Post.new(created_at: time)

    @output_buffer =
      bootstrap_form_for post do |form|
        form.hidden_field :created_at
      end

    assert_select 'input[type=hidden]#post_created_at'
    assert_select 'p.form-control-plaintext', 0

    reset_output_buffer!
    @output_buffer =
      bootstrap_form_for post, readonly: true do |form|
        form.hidden_field :created_at
      end
    assert_select 'input[type=hidden]#post_created_at', 0
    assert_select 'p.form-control-plaintext', 0
  end

  test 'readonly label should display translated text' do
    time = Time.current
    post = Post.new(updated_at: time)

    bootstrap_form_for post do |form|
      @output_buffer = form.label(:updated_at)
      assert_select 'label', text: I18n.t('activerecord.attributes.post.updated_at')
    end

    reset_output_buffer!
    bootstrap_form_for post, readonly: true do |form|
      @output_buffer = form.label(:updated_at)
      assert_select 'label', text: I18n.t('activerecord.attributes.post.updated_at')
    end
  end
end
