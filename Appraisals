if RUBY_VERSION < '2.4'
  appraise 'activesupport-4' do
    gem 'activesupport', '4.0.6'
  end
end

if RUBY_VERSION >= '2.3'
  appraise 'activesupport-5' do
    gem 'activesupport', '5.0.0'
  end

  appraise 'activesupport-5.2.2' do
    gem 'activesupport', '5.2.2'
  end
end

appraise 'rspec-3' do
  gem 'rspec', '3.0.0'
  gem 'activesupport', '4.0.6' if RUBY_VERSION < '2.3'
end

appraise 'rspec-3.8' do
  gem 'rspec', '3.8.0'
  gem 'activesupport', '4.0.6' if RUBY_VERSION < '2.3'
end
