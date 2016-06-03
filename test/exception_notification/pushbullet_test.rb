require 'test_helper'

class ExceptionNotification::PushbulletTest < Minitest::Test
  def test_raise_argument_error_when_users_is_nil
    assert_raises(ArgumentError) do
      ExceptionNotifier::PushbulletNotifier.new
    end
  end

  def test_default_title
    notifier = ExceptionNotifier::PushbulletNotifier.new(users: {})
    assert_equal 'New exception occurred.', notifier.title
  end

  def test_title_including_app_name_and_environemt_if_can_use
    notifier = ExceptionNotifier::PushbulletNotifier.new(users: {})

    notifier.stub :app, 'rails_app' do
      notifier.stub :environment, 'production' do
        assert_equal 'New exception occurred in rails_app(production).', notifier.title
      end
    end
  end

  def test_set_title_option
    notifier = ExceptionNotifier::PushbulletNotifier.new(users: {}, title: 'title')
    assert_equal 'title', notifier.title
  end

  def test_body
    notifier = ExceptionNotifier::PushbulletNotifier.new(users: {})
    assert_equal "'message'", notifier.body(ArgumentError.new('message'))
  end

  def test_get_devices_idens_from_api_when_idens_is_nil
    stub_request(:any, 'https://api.pushbullet.com/v2/devices').
      to_return(status: 200, body: '{"devices": [{"iden": "device_1"}]}')
    notifier = ExceptionNotifier::PushbulletNotifier.new(users: [{api_token: '123'}])
    assert_equal notifier.users.first[:device_idens], %w(device_1)
  end

  def test_call_create_note_in_call
    notifier = ExceptionNotifier::PushbulletNotifier.new(users: [{api_token: '123', device_idens: %w(device_1)}])

    exception = ArgumentError.new
    mock = Minitest::Mock.new
    mock.expect(:call, true, ['device_1', notifier.title, notifier.body(exception)])

    Pushbullet::Push.stub(:create_note, mock) do
      notifier.call(exception)
    end
    mock.verify
  end
end
