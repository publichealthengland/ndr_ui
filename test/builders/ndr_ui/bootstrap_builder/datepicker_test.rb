require 'test_helper'

# Test bootstrap form builder date picker
class DatepickerTest < ActionView::TestCase
  tests ActionView::Helpers::FormHelper
  include NdrUi::BootstrapHelper

  test 'datepicker_field' do
    post = Post.new

    bootstrap_form_for post do |form|
      assert_dom_equal(
        '<div class="input-group date" data-provide="datepicker">' \
        '<input class="form-control" type="text" name="post[created_at]" id="post_created_at" />' \
        '<span aria-hidden="true" class="input-group-text">' \
        '<span class="glyphicon glyphicon-calendar"></span>' \
        '</span>' \
        '</div>' \
        '<span class="form-text" data-feedback-for="post_created_at">' \
        '<span class="text-danger"></span><span class="text-warning"></span>' \
        '</span>',
        form.datepicker_field(:created_at)
      )
    end
  end

  test 'datepicker_field with no future dates' do
    post = Post.new

    bootstrap_form_for post do |form|
      assert_dom_equal(
        '<div class="input-group date" data-provide="datepicker" data-date-end-date="0d">' \
        '<input class="form-control" type="text" name="post[created_at]" id="post_created_at"/>' \
        '<span aria-hidden="true" class="input-group-text">' \
        '<span class="glyphicon glyphicon-calendar"></span>' \
        '</span>' \
        '</div>' \
        '<span class="form-text" data-feedback-for="post_created_at">' \
        '<span class="text-danger"></span><span class="text-warning"></span>' \
        '</span>',
        form.datepicker_field(:created_at, no_future: true)
      )
    end
  end

  test 'datepicker_field should display errors' do
    post = Post.new
    post.errors.add(:created_at, 'not')
    post.errors.add(:created_at, 'great')

    bootstrap_form_for post do |form|
      assert_dom_equal(
        '<div class="input-group date" data-provide="datepicker">' \
        '<input class="form-control" type="text" name="post[created_at]" id="post_created_at" />' \
        '<span aria-hidden="true" class="input-group-text">' \
        '<span class="glyphicon glyphicon-calendar"></span>' \
        '</span>' \
        '</div>' \
        '<span class="form-text" data-feedback-for="post_created_at">' \
        '<span class="text-danger">not<br>great</span><span class="text-warning"></span>' \
        '</span>',
        form.datepicker_field(:created_at)
      )
    end
  end

  test 'should display errors when readonly' do
    post = Post.new(created_at: Date.new(2001, 2, 3))
    post.errors.add(:created_at, 'not')
    post.errors.add(:created_at, 'great')

    bootstrap_form_for post, readonly: true do |form|
      assert form.readonly?
      assert_dom_equal(
        '<p class="form-control-plaintext">2001-02-03</p>' \
        '<span class="form-text" data-feedback-for="post_created_at">' \
        '<span class="text-danger">not<br>great</span><span class="text-warning"></span>' \
        '</span>',
        form.datepicker_field(:created_at)
      )
    end
  end

end
