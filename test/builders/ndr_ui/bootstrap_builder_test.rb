require 'test_helper'

module NdrUi
  # Test bootstrap form builder
  class BootstrapBuilderTest < ActionView::TestCase
    tests ActionView::Helpers::FormHelper
    include BootstrapHelper

    test 'form_for builder should be used' do
      post = Post.new
      bootstrap_form_for post do |form|
        assert_instance_of NdrUi::BootstrapBuilder, form
      end
    end

    test 'add_form_control_class text_area' do
      post = Post.new

      @output_buffer =
        bootstrap_form_for post do |form|
          form.text_area :updated_at
        end

      assert_select 'textarea.form-control'
    end

    test 'control_group' do
      post = Post.new
      bootstrap_form_for post do |form|
        assert_dom_equal(
          '<div class="form-group">' \
          '<label class="form-label" for="post_created_at">Created at</label>' \
          '<div>Apples</div></div>',
          form.control_group(:created_at, 'Created at', {}, {}, 'Apples')
        )

        assert_dom_equal(
          '<div class="form-group">' \
          '<label class="form-label" for="post_created_at">Created at</label>' \
          '<div>Apples</div></div>',
          form.control_group(:created_at, nil, {}, {}, 'Apples')
        )

        html = form.control_group(:created_at, 'Created at') do
          'Pears'
        end
        assert_dom_equal '<div class="form-group">' \
                         '<label class="form-label" for="post_created_at">Created at</label>' \
                         '<div>Pears</div></div>', html

        html = form.control_group(:created_at, 'Created at', class: 'col-md-2') do
          'Pears'
        end
        assert_dom_equal '<div class="form-group col-md-2">' \
                         '<label class="form-label" for="post_created_at">Created at</label>' \
                         '<div>Pears</div></div>', html

        html = form.control_group(:created_at, 'Created at', {}, id: 'dom_id') do
          'Pears'
        end
        assert_dom_equal '<div class="form-group">' \
                         '<label class="form-label" for="post_created_at">Created at</label>' \
                         '<div id="dom_id">Pears</div></div>', html

        assert_dom_equal(
          '<div class="form-group">' \
          '<label class="form-label" for="post_created_at">Created at ' \
          '<span title="Carrot" class="question-tooltip">' \
          '<span class="glyphicon glyphicon-question-sign"></span></span></label>' \
          '<div>Apples</div></div>',
          form.control_group(:created_at, 'Created at', { tooltip: 'Carrot' }, {}, 'Apples')
        )
      end
    end

    test 'control_group with errors and warnings' do
      post = Post.new
      post.errors.add(:created_at, 'FLUNK')
      post.stubs(:warnings).returns(created_at: 'FLUNK')
      bootstrap_form_for post do |form|
        html = form.control_group(:created_at, 'Created at') do
          'Pears'
        end
        assert_dom_equal '<div class="form-group has-error">' \
                         '<label class="form-label" for="post_created_at" class="col-form-label">Created at</label>' \
                         '<div>Pears</div></div>', html
      end
    end

    test 'horizontal control_group with errors and warnings' do
      post = Post.new
      post.errors.add(:created_at, 'FLUNK')
      post.stubs(:warnings).returns(created_at: 'FLUNK')
      bootstrap_form_for post, horizontal: true do |form|
        html = form.control_group(:created_at, 'Created at') do
          'Pears'
        end
        assert_dom_equal '<div class="form-group row has-error">' \
                         '<label class="col-form-label col-3 text-end" for="post_created_at">Created at</label>' \
                         '<div class="col-9">Pears</div></div>', html
      end
    end

    test 'control_group with errors' do
      post = Post.new
      post.errors.add(:created_at, 'FLUNK')
      bootstrap_form_for post do |form|
        html = form.control_group(:created_at, 'Created at') do
          'Pears'
        end
        assert_dom_equal '<div class="form-group has-error">' \
                         '<label class="form-label" for="post_created_at">Created at</label>' \
                         '<div>Pears</div></div>', html
      end
    end

    test 'horizontal control_group with errors' do
      post = Post.new
      post.errors.add(:created_at, 'FLUNK')
      bootstrap_form_for post, horizontal: true do |form|
        html = form.control_group(:created_at, 'Created at') do
          'Pears'
        end
        assert_dom_equal '<div class="form-group row has-error">' \
                         '<label class="col-form-label col-3 text-end" for="post_created_at">Created at</label>' \
                         '<div class="col-9">Pears</div></div>', html
      end
    end

    test 'control_group with warnings' do
      post = Post.new
      post.stubs(:warnings).returns(created_at: 'FLUNK')
      bootstrap_form_for post do |form|
        html = form.control_group(:created_at, 'Created at') do
          'Pears'
        end
        assert_dom_equal '<div class="form-group has-warning">' \
                         '<label class="form-label" for="post_created_at" class="col-form-label">Created at</label>' \
                         '<div>Pears</div></div>', html
      end
    end

    test 'horizontal control_group with warnings' do
      post = Post.new
      post.stubs(:warnings).returns(created_at: 'FLUNK')
      bootstrap_form_for post, horizontal: true do |form|
        html = form.control_group(:created_at, 'Created at') do
          'Pears'
        end
        assert_dom_equal '<div class="form-group row has-warning">' \
                         '<label class="col-form-label col-3 text-end" for="post_created_at">Created at</label>' \
                         '<div class="col-9">Pears</div></div>', html
      end
    end

    test 'horizontal_mode' do
      post = Post.new

      bootstrap_form_for(post) do |form|
        form.horizontal_mode = true
        assert_equal true, form.horizontal_mode

        form.horizontal_mode = '4'
        assert_equal '4', form.horizontal_mode

        form.horizontal_mode = nil
        assert_nil form.horizontal_mode
      end

      bootstrap_form_for post, horizontal: '6' do |form|
        assert_equal '6', form.horizontal_mode
      end

      bootstrap_form_for post do |form|
        assert_nil form.horizontal_mode
      end
    end

    test 'label_columns' do
      post = Post.new

      bootstrap_form_for(post) do |form|
        form.horizontal_mode = true
        assert_equal 3, form.label_columns

        form.horizontal_mode = '4'
        assert_equal '4', form.label_columns

        form.horizontal_mode = nil
        assert_nil form.label_columns
      end

      bootstrap_form_for post, horizontal: '6' do |form|
        assert_equal '6', form.label_columns
      end

      bootstrap_form_for post do |form|
        assert_nil form.label_columns
      end
    end
  end
end
