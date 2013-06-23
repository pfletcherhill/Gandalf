require 'spec_helper'

describe 'Routing' do
  it 'routes events' do
    expect(get: '/events').to route_to(
      controller: 'events',
      action: 'index'
    )
  end
end
